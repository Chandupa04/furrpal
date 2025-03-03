import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

      // Create dog profile document
      await _firestore.collection('users').doc(userId).collection('dogs').add({
        'name': name,
        'breed': breed,
        'gender': gender,
        'age': age,
        'healthConditions': healthConditions ?? '',
        'location': location,
        'image': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating dog profile: $e');
      throw e;
    }
  }

  // Get all dog profiles
  Future<List<Map<String, dynamic>>> getAllDogProfiles() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('dogs')
          .orderBy('createdAt', descending: true)
          .get();

      // Debug: Print the number of documents retrieved
      print('Retrieved ${snapshot.docs.length} dog profiles from Firestore');

      return snapshot.docs.map((doc) {
        // Convert DocumentSnapshot to Map and add the document ID
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID to the data

        // Debug: Print each document data
        print('Dog profile data: $data');

        return data;
      }).toList();
    } catch (e) {
      print('Error getting dog profiles: $e');
      throw e;
    }
  }
}
