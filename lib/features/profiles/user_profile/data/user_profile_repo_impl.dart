import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:furrpal/features/profiles/user/user_profile/domain/models/profile_user.dart';
import 'package:furrpal/features/profiles/user/user_profile/domain/repositories/profile_repo.dart';

class UserProfileRepoImpl implements ProfileRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  // get current user
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // get user document from firestore
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            fName: userData['first name'],
            lName: userData['last name'],
            phoneNumber: userData['phone number'],
            address: userData['address'],
            profileImageUrl: userData['profileImageUrl'].toString(),
            bio: userData['bio'] ?? '',
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUserProfile({
    required String uid,
    required String fName,
    required String lName,
    required String address,
    required String phoneNumber,
    String? bio,
  }) async {
    try {
      //convert updated profile to json store in firestore
      await firebaseFirestore.collection('users').doc(uid).update({
        'first name': fName,
        'last name': lName,
        'bio': bio,
        'address': address,
        'phone number': phoneNumber
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> uploadProfilePicture(
      {required File profileImage, required String userId}) async {
    try {
      final file = profileImage;
      final storageRef = storage.ref().child('dog_images/$userId');
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      await firebaseFirestore.collection('users').doc(currentUser!.uid).update({
        'profileImageUrl': downloadUrl,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
