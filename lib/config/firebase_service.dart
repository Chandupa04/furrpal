import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:math' show min;

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a dog profile
  Future<void> createDogProfile({
    required String name,
    required String breed,
    required String gender,
    required String age,
    String? healthConditions,
    required String location,
    File? imageFile,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Error: No user logged in');
      throw Exception('No user logged in');
    }
    String userId = user.uid;
    print('Creating dog profile for user: $userId');

    try {
      // generate a unique ID for the dog
      DocumentReference reference =
          _firestore.collection('users').doc(userId).collection('dogs').doc();
      String dogId = reference.id;

      // Upload image if provided
      String? imageUrl;
      if (imageFile != null) {
        print('Image file exists: ${imageFile.existsSync()}');
        print('Image file size: ${imageFile.lengthSync()} bytes');

        // Create a unique filename
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
        final storageRef = _storage.ref().child('dog_images/$userId/$fileName');
        print('Storage path: ${storageRef.fullPath}');

        try {
          final uploadTask = storageRef.putFile(imageFile);
          final snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
          print('Image uploaded successfully. URL: $imageUrl');

          // Verify the URL is accessible
          try {
            final response = await HttpClient().getUrl(Uri.parse(imageUrl));
            final httpResponse = await response.close();
            print(
                'Image URL is accessible. Status code: ${httpResponse.statusCode}');
          } catch (e) {
            print('Warning: Could not verify image URL accessibility: $e');
          }
        } catch (e) {
          print('Error uploading image: $e');
          throw Exception('Failed to upload image: $e');
        }
      }

      // Create dog profile document
      final dogData = {
        'dog_id': dogId,
        'name': name,
        'breed': breed,
        'gender': gender,
        'age': age,
        'healthConditions': healthConditions ?? '',
        'location': location,
        'imageUrl': imageUrl ?? '', // Changed from 'image' to 'imageUrl'
        'createdAt': FieldValue.serverTimestamp(),
        'likes': [],
        'dislikes': [],
      };
      print('Creating dog document with data: $dogData');

      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dogs')
          .doc(dogId)
          .set(dogData);
      // .add(dogData);
      reference.set(dogData);
      print('Dog profile created successfully with ID: $dogId');

      // Verify the document was created
      // final docSnapshot = await docRef.get();
      // if (docSnapshot.exists) {
      //   print('Verified document exists with data: ${docSnapshot.data()}');
      // } else {
      //   print('Error: Document was not created');
      //   throw Exception('Failed to create dog profile document');
      // }
    } catch (e) {
      print('Error creating dog profile: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllDogProfilesByBreedPriority(
      String breedQuery) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return [];
      }

      // First, get the dog profiles liked by current user to filter them out later
      final QuerySnapshot likesSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('likes')
          .get();

      // Create a set of liked dog IDs for faster lookup
      final Set<String> likedDogIds = likesSnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['dogId'] as String)
          .toSet();

      print('User has liked ${likedDogIds.length} dog profiles');

      print('Fetching dogs with breed priority for: $breedQuery');
      final queryLower = breedQuery.toLowerCase();

      final QuerySnapshot usersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, isNotEqualTo: currentUser.uid)
          .get();

      List<Map<String, dynamic>> allDogs = [];

      for (var userDoc in usersSnapshot.docs) {
        final QuerySnapshot dogsSnapshot = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('dogs')
            .orderBy('createdAt', descending: true)
            .get();

        final dogs = dogsSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['ownerId'] = userDoc.id;
          return data;
        }).toList();

        allDogs.addAll(dogs);
      }

      print('Found ${allDogs.length} total dogs before any filtering');

      // Filter out dogs that have been liked
      allDogs =
          allDogs.where((dog) => !likedDogIds.contains(dog['id'])).toList();

      print(
          'After filtering liked profiles: ${allDogs.length} profiles remain');

      // Sort dogs: exact breed match first, then partial matches, then others
      allDogs.sort((a, b) {
        final breedA = (a['breed'] ?? '').toString().toLowerCase();
        final breedB = (b['breed'] ?? '').toString().toLowerCase();

        int score(String breed) {
          if (breed == queryLower) return 2;
          if (breed.contains(queryLower)) return 1;
          return 0;
        }

        return score(breedB).compareTo(score(breedA));
      });

      // Count matches for debugging
      int exactMatches = allDogs
          .where((dog) =>
              (dog['breed'] ?? '').toString().toLowerCase() == queryLower)
          .length;
      int partialMatches = allDogs
          .where((dog) =>
              (dog['breed'] ?? '')
                  .toString()
                  .toLowerCase()
                  .contains(queryLower) &&
              (dog['breed'] ?? '').toString().toLowerCase() != queryLower)
          .length;

      print(
          'Found $exactMatches exact matches and $partialMatches partial matches for breed: $breedQuery');
      print('First few dogs after sorting:');
      for (var i = 0; i < min(3, allDogs.length); i++) {
        print('${i + 1}. ${allDogs[i]['name']} (${allDogs[i]['breed']})');
      }

      return allDogs;
    } catch (e) {
      print('Error fetching breed prioritized dog profiles: $e');
      rethrow;
    }
  }

  // Get all dog profiles
  Future<List<Map<String, dynamic>>> getAllDogProfiles() async {
    try {
      // Get current user
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return [];
      }

      // First, get the dog profiles liked by current user to filter them out later
      final QuerySnapshot likesSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('likes')
          .get();

      // Create a set of liked dog IDs for faster lookup
      final Set<String> likedDogIds = likesSnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['dogId'] as String)
          .toSet();

      print('User has liked ${likedDogIds.length} dog profiles');

      // Get all users except current user
      final QuerySnapshot usersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, isNotEqualTo: currentUser.uid)
          .get();

      List<Map<String, dynamic>> allDogs = [];

      // For each user, get their dogs
      for (var userDoc in usersSnapshot.docs) {
        final QuerySnapshot dogsSnapshot = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('dogs')
            .orderBy('createdAt', descending: true)
            .get();

        final dogs = dogsSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['ownerId'] = userDoc.id; // Add the owner's ID
          return data;
        }).toList();

        allDogs.addAll(dogs);
      }

      // Filter out dogs that have been liked
      final filteredDogs =
          allDogs.where((dog) => !likedDogIds.contains(dog['id'])).toList();

      print('Retrieved ${allDogs.length} total dog profiles from Firestore');
      print(
          'After filtering liked profiles: ${filteredDogs.length} profiles remain');

      return filteredDogs;
    } catch (e) {
      print('Error getting dog profiles: $e');
      rethrow;
    }
  }

  // Get user profile data by ID
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        print('User document not found for ID: $userId');
        return null;
      }

      return userDoc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Check if user has reached the 24-hour like limit
  Future<bool> hasReachedLikeLimit(String userId) async {
    try {
      // Get likes from the last 24 hours
      final DateTime now = DateTime.now();
      final DateTime twentyFourHoursAgo =
          now.subtract(const Duration(hours: 24));

      final QuerySnapshot likesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('likes')
          .where('timestamp', isGreaterThanOrEqualTo: twentyFourHoursAgo)
          .get();

      print('Number of likes in last 24 hours: ${likesSnapshot.docs.length}');
      return likesSnapshot.docs.length >= 6;
    } catch (e) {
      print('Error checking like limit: $e');
      return false;
    }
  }

  // Store a like interaction with timestamp
  Future<void> storeDogLike({
    required String currentUserId,
    required String dogOwnerId,
    required String dogId,
    required String dogName,
    required String likedByDogId, // The dog that liked the profile
    required String likedByUserId,
  }) async {
    try {
      print('Starting to store like for dog: $dogName');

      // Check if user has reached the 24-hour limit
      final bool hasReachedLimit = await hasReachedLikeLimit(currentUserId);
      if (hasReachedLimit) {
        print('User has reached the 24-hour like limit');
        throw Exception(
            'You have reached the 24-hour like limit. Please upgrade to continue.');
      }

      // await _firestore
      //     .collection('users')
      //     .doc(dogOwnerId)
      //     .collection('notifications')
      //     .add({
      //   'type': 'like',
      //   'dogId': dogId,
      //   'dogName': dogName,
      //   'likedByUserId': likedByUserId,
      //   'likedByUserName': likedByUserName,
      //   'likedByUserProfilePic': likedByUserProfilePic,
      //   'timestamp': FieldValue.serverTimestamp(),
      //   'likedByDogId':
      //       likedByDogId, // Storing the dog ID that liked the profile
      // });

      // Get current user details with full name
      final userDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      if (!userDoc.exists) {
        print('Error: User document not found for ID: $currentUserId');
        return;
      }

      final userData = userDoc.data();
      if (userData == null) {
        print('Error: User data is null for ID: $currentUserId');
        return;
      }

      // Get the user's first and last name
      final String firstName = userData['firstName'] ?? '';
      final String lastName = userData['lastName'] ?? '';
      final String fullName = firstName.isNotEmpty && lastName.isNotEmpty
          ? '$firstName $lastName'
          : firstName.isNotEmpty
              ? firstName
              : lastName.isNotEmpty
                  ? lastName
                  : 'A user';

      print('Storing like for user: $fullName');

      // Get the current dog document
      final dogRef = _firestore
          .collection('users')
          .doc(dogOwnerId)
          .collection('dogs')
          .doc(dogId);

      // Get current likes array
      final dogDoc = await dogRef.get();
      if (!dogDoc.exists) {
        print('Error: Dog document not found for ID: $dogId');
        return;
      }

      final dogData = dogDoc.data();
      if (dogData == null) {
        print('Error: Dog data is null for ID: $dogId');
        return;
      }

      List<dynamic> currentLikes = dogData['likes'] ?? [];
      print('Current likes before update: $currentLikes');

      // Check if user already liked this dog
      if (currentLikes.contains(currentUserId)) {
        print('User already liked this dog');
        return;
      }

      // Create a unique notification ID to prevent duplicates
      final String notificationId =
          '${dogOwnerId}_${dogId}_${currentUserId}_like';

      // Check for existing notification using the unique ID
      print('Checking for existing notification with ID: $notificationId');
      final existingNotification = await _firestore
          .collection('users')
          .doc(dogOwnerId)
          .collection('notifications')
          .doc(notificationId)
          .get();

      if (existingNotification.exists) {
        print('Notification already exists, skipping...');
        return;
      }

      // Add the new like
      currentLikes.add(currentUserId);

      // Update the likes array
      await dogRef.update({
        'likes': currentLikes,
      });

      // Store the like with timestamp
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('likes')
          .add({
        'dogId': dogId,
        'dogOwnerId': dogOwnerId,
        'dogName': dogName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Verify the update
      final updatedDogDoc = await dogRef.get();
      final updatedDogData = updatedDogDoc.data();
      if (updatedDogData != null) {
        print('Updated likes array: ${updatedDogData['likes']}');
      }

      // Get user profile picture if available
      String userProfilePic = userData['profilePicture'] ?? '';

      // Create notification for dog owner using the unique ID
      print('Creating notification for dog owner: $dogOwnerId');
      final notificationRef = _firestore
          .collection('users')
          .doc(dogOwnerId)
          .collection('notifications')
          .doc(notificationId);

      await notificationRef.set({
        'type': 'like',
        'dogId': dogId,
        'dogName': dogName,
        'likedByUserId': currentUserId,
        'likedByUserName': fullName,
        'likedByUserProfilePic': userProfilePic,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'message': 'Your dog $dogName is getting popular!',
        'likedDogId': dogId,
        'likedByDogId': likedByDogId,
      });

      print('Notification created with ID: ${notificationRef.id}');

      // Verify notification was created
      final notificationDoc = await notificationRef.get();
      if (notificationDoc.exists) {
        print('Notification data: ${notificationDoc.data()}');
      } else {
        print('Error: Notification document was not created');
      }

      print('Like and notification stored successfully');
    } catch (e) {
      print('Error storing dog like: $e');
      rethrow;
    }
  }

  // Store a dislike interaction
  Future<void> storeDogDislike({
    required String currentUserId,
    required String dogId,
    required String dogOwnerId,
    required String dogName,
  }) async {
    try {
      // Get current user details
      final userDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      if (!userDoc.exists) {
        print('Error: User document not found');
        return;
      }

      final userData = userDoc.data();
      if (userData == null) {
        print('Error: User data is null');
        return;
      }

      final String firstName = userData['firstName'] ?? '';
      final String lastName = userData['lastName'] ?? '';
      final String fullName = firstName.isNotEmpty && lastName.isNotEmpty
          ? '$firstName $lastName'
          : firstName.isNotEmpty
              ? firstName
              : lastName.isNotEmpty
                  ? lastName
                  : 'A user';

      print('Storing dislike for user: $fullName');

      // Get the current dog document
      final dogRef = _firestore
          .collection('users')
          .doc(dogOwnerId)
          .collection('dogs')
          .doc(dogId);

      // Get current dislikes array
      final dogDoc = await dogRef.get();
      if (!dogDoc.exists) {
        print('Error: Dog document not found');
        return;
      }

      final dogData = dogDoc.data();
      if (dogData == null) {
        print('Error: Dog data is null');
        return;
      }

      List<dynamic> currentDislikes = dogData['dislikes'] ?? [];
      print('Current dislikes before update: $currentDislikes');

      // Check if user already disliked this dog
      if (currentDislikes.contains(currentUserId)) {
        print('User already disliked this dog');
        return;
      }

      // Add the new dislike
      currentDislikes.add(currentUserId);

      // Update the dislikes array
      await dogRef.update({
        'dislikes': currentDislikes,
      });

      // Verify the update
      final updatedDogDoc = await dogRef.get();
      final updatedDogData = updatedDogDoc.data();
      if (updatedDogData != null) {
        print('Updated dislikes array: ${updatedDogData['dislikes']}');
      }

      print(
          'Dislike stored successfully for dog: $dogId by user: $currentUserId');
    } catch (e) {
      print('Error storing dog dislike: $e');
      rethrow;
    }
  }

  // Check if current user has liked a dog
  Future<bool> hasUserLikedDog(String dogId, String userId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      String currentUserId = currentUser.uid;

      DocumentSnapshot dogDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dogs')
          .doc(dogId)
          .get();

      if (!dogDoc.exists) return false;

      Map<String, dynamic> data = dogDoc.data() as Map<String, dynamic>;
      List<dynamic> likes = data['likes'] ?? [];

      return likes.contains(currentUserId);
    } catch (e) {
      print('Error checking if user liked dog: $e');
      return false;
    }
  }

  // Check if current user has disliked a dog
  Future<bool> hasUserDislikedDog(String dogId, String userId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      String currentUserId = currentUser.uid;

      DocumentSnapshot dogDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dogs')
          .doc(dogId)
          .get();

      if (!dogDoc.exists) return false;

      Map<String, dynamic> data = dogDoc.data() as Map<String, dynamic>;
      List<dynamic> dislikes = data['dislikes'] ?? [];

      return dislikes.contains(currentUserId);
    } catch (e) {
      print('Error checking if user disliked dog: $e');
      return false;
    }
  }

  // Upload and update user profile image
  Future<String?> uploadUserProfileImage(String userId, File imageFile) async {
    try {
      print('Starting profile image upload for user: $userId');
      print('Image file size: ${imageFile.lengthSync()} bytes');

      // Create a unique filename
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final storageRef =
          _storage.ref().child('profile_images/$userId/$fileName');

      print('Uploading to storage path: ${storageRef.fullPath}');

      // Upload the file
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('Image uploaded successfully. URL: $downloadUrl');

      // Only update the user document if it already exists
      // During registration, the document doesn't exist yet
      try {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          print('Updating existing user document with profile image URL');
          await _firestore.collection('users').doc(userId).update({
            'profileImageUrl': downloadUrl,
          });
        } else {
          print('User document does not exist yet, skipping Firestore update');
        }
      } catch (e) {
        print('Note: Could not update user document: $e');
        // Don't rethrow here, as we still want to return the download URL
      }

      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // Get user details by ID
  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        print('User document not found for ID: $userId');
        return null;
      }

      final userData = userDoc.data();
      if (userData == null) {
        print('User data is null for ID: $userId');
        return null;
      }

      // Get first and last name with correct field names
      final String firstName = userData['first name'] ?? '';
      final String lastName = userData['last name'] ?? '';

      // Combine names with proper spacing
      final String fullName = firstName.isNotEmpty && lastName.isNotEmpty
          ? '$firstName $lastName'
          : firstName.isNotEmpty
              ? firstName
              : lastName.isNotEmpty
                  ? lastName
                  : 'Unknown User';

      // Format the data to match what we need
      return {
        'name': fullName,
        'email': userData['email'] ?? 'Not provided',
        'address': userData['address'] ?? 'Not provided',
        'contact': userData['phone number'] ?? 'Not provided',
        'since': userData['created_at'] != null
            ? 'since ${(userData['created_at'] as Timestamp).toDate().year}'
            : 'Not provided',
        'imagePath': userData['profileImageUrl'] ?? '',
      };
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  // Get a specific dog profile by ID regardless of like status
  Future<Map<String, dynamic>?> getDogProfileById(
      String dogId, String ownerId) async {
    try {
      print('Fetching dog profile with ID: $dogId from owner: $ownerId');

      final doc = await _firestore
          .collection('users')
          .doc(ownerId)
          .collection('dogs')
          .doc(dogId)
          .get();

      if (!doc.exists) {
        print('Dog profile not found for dogId: $dogId and ownerId: $ownerId');
        return null;
      }

      Map<String, dynamic> dogData = doc.data() as Map<String, dynamic>;
      // Add the ID and owner ID to the data
      dogData['id'] = dogId;
      dogData['ownerId'] = ownerId;

      print('Successfully fetched dog profile: ${dogData['name']}');
      return dogData;
    } catch (e) {
      print('Error fetching dog profile: $e');
      return null;
    }
  }
}
