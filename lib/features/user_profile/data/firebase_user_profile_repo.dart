import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furrpal/features/user_profile/domain/models/profile_user.dart';
import 'package:furrpal/features/user_profile/domain/repositories/profile_repo.dart';

class FirebaseUserProfileRepo implements ProfileRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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
            phoneNumber: userData['phone number'] ?? '',
            address: userData['address'] ?? '',
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
  Future<void> updateUserProfile(ProfileUser updateProfile) async {
    try {
      //convert updated profile to json store in firestore
      await firebaseFirestore
          .collection('users')
          .doc(updateProfile.uid)
          .update({
        'profileImageUrl': updateProfile.profileImageUrl,
        'bio': updateProfile.bio,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
