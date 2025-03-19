import 'package:furrpal/features/profiles/user_profile/domain/models/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateUserProfile(ProfileUser updateProfile);
}
