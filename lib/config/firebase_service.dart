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
    String userId = user!.uid;

    try {
      // Upload image if provided
      String? imageUrl;
      if (imageFile != null) {
        final storageRef = _storage
            .ref()
            .child('dog_images/${DateTime
            .now()
            .millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(imageFile);
        final snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      // Create dog profile document with empty likes and dislikes arrays
      await _firestore.collection('users').doc(userId).collection('dogs').add({
        'name': name,
        'breed': breed,
        'gender': gender,
        'age': age,
        'healthConditions': healthConditions ?? '',
        'location': location,
        'image': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'likes': [], // Initialize empty likes array
        'dislikes': [], // Initialize empty dislikes array
      });
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
          'Retrieved ${allDogs
              .length} dog profiles from Firestore (excluding current user)');
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

  // Store a like interaction
  Future<void> storeDogLike({
    required String currentUserId,
    required String dogOwnerId,
    required String dogId,
    required String dogName,
  }) async {
    try {
      print('Starting to store like for dog: $dogName');

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

      // Check for existing notification BEFORE updating likes
      print('Checking for existing notifications...');
      final existingNotifications = await _firestore
          .collection('users')
          .doc(dogOwnerId)
          .collection('notifications')
          .where('type', isEqualTo: 'like')
          .where('dogId', isEqualTo: dogId)
          .where('likedByUserId', isEqualTo: currentUserId)
          .get();

      print(
          'Found ${existingNotifications.docs.length} existing notifications');

      if (existingNotifications.docs.isNotEmpty) {
        print('Notification already exists for this like, skipping...');
        return;
      }

      // Add the new like
      currentLikes.add(currentUserId);

      // Update the likes array
      await dogRef.update({
        'likes': currentLikes,
      });

      // Verify the update
      final updatedDogDoc = await dogRef.get();
      final updatedDogData = updatedDogDoc.data();
      if (updatedDogData != null) {
        print('Updated likes array: ${updatedDogData['likes']}');
      }

      // Get user profile picture if available
      String userProfilePic = userData['profilePicture'] ?? '';

      // Create notification for dog owner
      print('Creating notification for dog owner: $dogOwnerId');
      final notificationRef = await _firestore
          .collection('users')
          .doc(dogOwnerId)
          .collection('notifications')
          .add({
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
