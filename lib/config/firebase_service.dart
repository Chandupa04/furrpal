import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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
          .add(dogData);
      print('Dog profile created successfully with ID: ${docRef.id}');

      // Verify the document was created
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        print('Verified document exists with data: ${docSnapshot.data()}');
      } else {
        print('Error: Document was not created');
        throw Exception('Failed to create dog profile document');
      }
    } catch (e) {
      print('Error creating dog profile: $e');
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

      print(
          'Retrieved ${allDogs.length} dog profiles from Firestore (excluding current user)');
      return allDogs;
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
}
