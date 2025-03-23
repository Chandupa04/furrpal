import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:furrpal/features/profiles/dog_profile/domain/models/dog_entity.dart';
import 'package:furrpal/features/profiles/dog_profile/domain/repositories/dog_profile_repo.dart';

class DogProfileRepoImpl implements DogProfileRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Future<List<DogEntity>> fetchDogProfiles() async {
    try {
      final dogDoc = await firebaseFirestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('dogs')
          .get();

      return dogDoc.docs.map((doc) {
        final dogData = doc.data();
        return DogEntity.fromJson(dogData);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateDogProfile({
    required String dogId,
    required String name,
    required String age,
    required String weightKg,
    required String weightG,
    required String breed,
    required String gender,
    required String location,
    required String bloodline,
    String? healthReportUrl,
  }) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('dogs')
          .doc(dogId)
          .update({
        'name': name,
        'age': age,
        'breed': breed,
        'gender': gender,
        'location': location,
        'bloodline': bloodline,
        'weightKg': weightKg,
        'weightG': weightG,
        'healthReportUrl': healthReportUrl,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateDogProfileImage(
      {required File profileImage, required String dogId}) async {
    try {
      final file = profileImage;
      final storageRef = storage.ref().child('dog_images/$dogId');
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      await firebaseFirestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('dogs')
          .doc(dogId)
          .update({
        'imageUrl': downloadUrl,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> addNewDogProfile({
    required File profileImage,
    required String name,
    required String age,
    required String weightKg,
    required String weightG,
    required String breed,
    required String gender,
    required String location,
    required String bloodline,
    String? healthReportUrl,
  }) async {
    try {
      // generate a unique ID for the dog
      DocumentReference reference = firebaseFirestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('dogs')
          .doc();
      String dogId = reference.id;

      final file = profileImage;
      final storageRef = storage.ref().child('dog_images/$dogId');
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      DogEntity dog = DogEntity(
        dogId: dogId,
        name: name,
        breed: breed,
        gender: gender,
        age: age,
        weightKg: weightKg,
        weightG: weightG,
        location: location,
        imageURL: downloadUrl,
        bloodline: bloodline,
        healthReportUrl: healthReportUrl,
      );
      await firebaseFirestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('dogs')
          .doc(dogId)
          .set(dog.toJson());
      dog;
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteDogProfile(String dogId) async {
    DocumentReference reference = firebaseFirestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('dogs')
        .doc(dogId);
    reference.delete();
  }
}
