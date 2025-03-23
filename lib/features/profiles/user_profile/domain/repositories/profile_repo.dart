import 'dart:io';

import 'package:furrpal/features/profiles/user/user_profile/domain/models/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<bool> updateUserProfile({
    required String uid,
    required String fName,
    required String lName,
    required String address,
    required String phoneNumber,
    String? bio,
  });
  Future<bool> uploadProfilePicture({
    required File profileImage,
    required String userId,
  });
}
