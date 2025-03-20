import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furrpal/features/profiles/dog_profile/domain/models/dog_entity.dart';
import 'package:furrpal/features/profiles/dog_profile/domain/repositories/dog_profile_repo.dart';

class FirebaseDogProfileRepo implements DogProfileRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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
        // (
        // dogId: dogId,
        // name: dogData['name'],
        // breed: dogData['breed'],
        // gender: dogData['gender'],
        // age: dogData['age'],
        // healthConditions: dogData['healthConditions'],
        // location: dogData['location'],
        // );
      }).toList();

      // if (dogDoc.exists) {
      //   final dogData = dogDoc.data();
      //   if (dogData != null) {
      //     return DogEntity(
      //       dogId: dogId,
      //       name: dogData['name'],
      //       breed: dogData['breed'],
      //       gender: dogData['gender'],
      //       age: dogData['age'],
      //       healthConditions: dogData['healthConditions'],
      //       location: dogData['location'],
      //     );
      //   }
      // }
      // return null;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateDogProfile(DogEntity updateProfile) async {}
}
