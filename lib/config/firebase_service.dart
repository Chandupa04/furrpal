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

      // Create dog profile document in the main collection
      DocumentReference dogRef = await _firestore.collection('dogs').add({
        'name': name,
        'breed': breed,
        'gender': gender,
        'age': age,
        'healthConditions': healthConditions ?? '',
        'location': location,
        'image': imageUrl ?? '',
        'ownerId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Created dog profile with ID: ${dogRef.id}');
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

      print('Retrieved ${snapshot.docs.length} dog profiles from Firestore');

      return _processQuerySnapshot(snapshot);
    } catch (e) {
      print('Error getting dog profiles: $e');
      throw e;
    }
  }

  // Get filtered dog profiles - IMPROVED VERSION
  Future<List<Map<String, dynamic>>> getFilteredDogProfiles({
    String? breed,
    String? gender,
    String? age,
  }) async {
    try {
      print('Starting filter query with: Breed=$breed, Gender=$gender, Age=$age');

      // Get all dogs first
      QuerySnapshot snapshot = await _firestore.collection('dogs').get();
      print('Retrieved ${snapshot.docs.length} total dog profiles from Firestore');

      // Convert to list of maps for easier processing
      List<Map<String, dynamic>> allDogs = _processQuerySnapshot(snapshot);

      // Debug: Print a sample of the data to see what we're working with
      if (allDogs.isNotEmpty) {
        print('Sample dog data: ${allDogs.first}');
      }

      // Apply filters in memory
      List<Map<String, dynamic>> filteredDogs = allDogs.where((dog) {
        // Debug each filter separately
        bool matchesBreed = true;
        if (breed != null && breed.isNotEmpty) {
          // More flexible breed matching
          String dogBreed = (dog['breed'] ?? '').toString().trim().toLowerCase();
          String filterBreed = breed.trim().toLowerCase();
          matchesBreed = dogBreed.contains(filterBreed) || filterBreed.contains(dogBreed);
          print('Dog ${dog['name']} breed: ${dog['breed']} - Matches filter "$breed": $matchesBreed');
        }

        bool matchesGender = true;
        if (gender != null && gender.isNotEmpty) {
          // Case-insensitive comparison for gender
          matchesGender = dog['gender']?.toString().trim().toLowerCase() == gender.trim().toLowerCase();
          print('Dog ${dog['name']} gender: ${dog['gender']} - Matches filter "$gender": $matchesGender');
        }

        bool matchesAge = true;
        if (age != null && age.isNotEmpty) {
          String ageRange = _extractAgeValue(age);
          String dogAge = (dog['age'] ?? '').toString().trim().toLowerCase();

          // Handle different age formats
          if (ageRange == '0-1') {
            // Puppy: age 0-1
            matchesAge = dogAge == '0' || dogAge == '1' ||
                dogAge == '0-1' || dogAge.contains('puppy');
          } else if (ageRange == '1-3') {
            // Young: age 1-3
            matchesAge = dogAge == '1' || dogAge == '2' || dogAge == '3' ||
                dogAge == '1-3' || dogAge.contains('young');
          } else if (ageRange == '3-7') {
            // Adult: age 3-7
            int? dogAgeNum = int.tryParse(dogAge);
            matchesAge = (dogAgeNum != null && dogAgeNum >= 3 && dogAgeNum <= 7) ||
                dogAge == '3-7' || dogAge.contains('adult');
          } else if (ageRange == '7+') {
            // Senior: age 7+
            int? dogAgeNum = int.tryParse(dogAge);
            matchesAge = (dogAgeNum != null && dogAgeNum >= 7) ||
                dogAge == '7+' || dogAge.contains('senior');
          }
          print('Dog ${dog['name']} age: ${dog['age']} - Matches filter "$age" ($ageRange): $matchesAge');
        }

        return matchesBreed && matchesGender && matchesAge;
      }).toList();

      print('After filtering: ${filteredDogs.length} dogs match the criteria');

      // Debug: Print the breeds of all matching dogs
      print('Matching breeds: ${filteredDogs.map((dog) => dog['breed']).toSet().toList()}');

      return filteredDogs;
    } catch (e) {
      print('Error getting filtered dog profiles: $e');
      throw e;
    }
  }

  // Process query snapshot into a list of maps
  List<Map<String, dynamic>> _processQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Helper method to extract age value from age category
  String _extractAgeValue(String ageCategory) {
    if (ageCategory.contains('Puppy')) {
      return '0-1';
    } else if (ageCategory.contains('Young')) {
      return '1-3';
    } else if (ageCategory.contains('Adult')) {
      return '3-7';
    } else if (ageCategory.contains('Senior')) {
      return '7+';
    }
    return ageCategory;
  }
}

