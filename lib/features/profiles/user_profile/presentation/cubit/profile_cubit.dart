import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furrpal/features/profiles/user_profile/domain/repositories/profile_repo.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/cubit/profile_state.dart';
import 'package:furrpal/features/profiles/user_profile/user_profile_picture/domain/profile_picture_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final ProfilePictureRepo pictureRepo;
  ProfileCubit({required this.profileRepo, required this.pictureRepo})
      : super(ProfileInitial());

  //fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final profile = await profileRepo.fetchUserProfile(uid);
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(ProfileError('User not found'));
      }
    } catch (e) {
      ProfileError(e.toString());
    }
  }

  //update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? newFName,
    String? newLName,
    String? newBio,
    String? newAddress,
    String? newPhoneNumber,
    String? profileImagePath,
  }) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }
      //profile image update
      String? imageDownloadUrl;

      if (profileImagePath != null) {
        imageDownloadUrl =
            await pictureRepo.uploadProfilePicture(profileImagePath, uid);
      }
      if (imageDownloadUrl == null) {
        emit(ProfileError('Failed to upload profile Image'));
        return;
      }

      //update new profile
      final updateProfile = currentUser.copyWith(
        newFName: newFName ?? currentUser.fName,
        newLName: newLName ?? currentUser.lName,
        newBio: newBio ?? currentUser.bio,
        newAddress: newAddress ?? currentUser.address,
        newPhoneNumber: newPhoneNumber ?? currentUser.phoneNumber,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );
      await profileRepo.updateUserProfile(updateProfile);
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError('Error updating profile: $e'));
    }
  }
}
