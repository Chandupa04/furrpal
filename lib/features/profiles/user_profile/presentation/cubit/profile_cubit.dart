import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furrpal/features/profiles/user_profile/domain/repositories/profile_repo.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

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
  Future<bool> updateUserProfile({
    required String uid,
    required String newFName,
    required String newLName,
    required String newAddress,
    required String newPhoneNumber,
    String? newBio,
  }) async {
    emit(ProfileLoading());
    try {
      // final currentUser = await profileRepo.fetchUserProfile(uid);

      // if (currentUser == null) {
      //   emit(ProfileError("Failed to fetch user for profile update"));
      //   return;
      // }

      // //update new profile
      // final updateProfile = currentUser.copyWith(
      //   newFName: newFName ?? currentUser.fName,
      //   newLName: newLName ?? currentUser.lName,
      //   newBio: newBio ?? currentUser.bio,
      //   newAddress: newAddress ?? currentUser.address,
      //   newPhoneNumber: newPhoneNumber ?? currentUser.phoneNumber,
      // );
      final updateProfile = await profileRepo.updateUserProfile(
        uid: uid,
        fName: newFName,
        lName: newLName,
        address: newAddress,
        phoneNumber: newPhoneNumber,
        bio: newBio,
      );
      if (updateProfile == true) {
        await fetchUserProfile(uid);
        return true;
      } else {
        emit(ProfileError('Failed to update profile details.'));
        return false;
      }
    } catch (e) {
      emit(ProfileError('Error updating profile: $e'));
      return false;
    }
  }

  // update user profile image
  Future<bool> uploadProfilePicture(File file, String userId) async {
    emit(ProfileLoading());
    try {
      final updatedDog = await profileRepo.uploadProfilePicture(
        profileImage: file,
        userId: userId,
      );

      if (updatedDog == true) {
        fetchUserProfile(userId);
        return true;
      } else {
        emit(ProfileError("Failed to update dog profile image."));
        return false;
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
      return false;
    }
  }
}
