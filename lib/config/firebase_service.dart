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
            .child('dog_images/${DateTime.now().millisecondsSinceEpoch}');
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
      throw e;
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
      throw e;
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

      final String userName = userData['firstName'] ?? 'A user';
      print('Storing like for user: $userName');

      // Get the current dog document
      final dogRef = _firestore
          .collection('users')
          .doc(dogOwnerId)
          .collection('dogs')
          .doc(dogId);

      // Get current likes array
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

      List<dynamic> currentLikes = dogData['likes'] ?? [];
      print('Current likes before update: $currentLikes');

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

      // Add notification for dog owner
      await _firestore
          .collection('users')
          .doc(dogOwnerId)
          .collection('notifications')
          .add({
        'type': 'like',
        'dogId': dogId,
        'dogName': dogName,
        'likedByUserId': currentUserId,
        'likedByUserName': userName,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      print('Like stored successfully for dog: $dogId by user: $currentUserId');
    } catch (e) {
      print('Error storing dog like: $e');
      throw e;
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

      final String userName = userData['firstName'] ?? 'A user';
      print('Storing dislike for user: $userName');

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
      throw e;
    }
  }
}
