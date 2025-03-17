import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furrpal/features/user_profile/domain/repositories/profile_repo.dart';
import 'package:furrpal/features/user_profile/presentation/cubit/profile_state.dart';

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
  Future<void> updateUserProfile({
    required String uid,
    String? newFName,
    String? newLName,
    String? newBio,
    String? newAddress,
    String? newPhoneNumber,
  }) async {
    emit(ProfileLoading());
    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }

      //update new profile
      final updateProfile = currentUser.copyWith(
        newFName: newFName ?? currentUser.fName,
        newLName: newLName ?? currentUser.lName,
        newBio: newBio ?? currentUser.bio,
        newAddress: newAddress ?? currentUser.address,
        newPhoneNumber: newPhoneNumber ?? currentUser.phoneNumber,
      );
      await profileRepo.updateUserProfile(updateProfile);
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError('Error updating profile: $e'));
    }
  }
}
