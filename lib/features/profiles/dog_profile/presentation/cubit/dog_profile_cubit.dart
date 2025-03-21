import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furrpal/features/profiles/dog_profile/domain/models/dog_entity.dart';
import 'package:furrpal/features/profiles/dog_profile/domain/repositories/dog_profile_repo.dart';
import 'dog_profile_state.dart';

class DogProfileCubit extends Cubit<DogProfileState> {
  final DogProfileRepo dogProfileRepo;
  // DogEntity? currentDogProfile;
  DogProfileCubit({required this.dogProfileRepo}) : super(DogProfileInitial());

  Future<void> fetchDogProfiles() async {
    try {
      emit(DogProfileLoading());
      final List<DogEntity> dogProfiles =
          await dogProfileRepo.fetchDogProfiles();

      emit(DogProfileLoaded(dogProfiles));
    } catch (e) {
      DogProfileError(e.toString());
    }
  }

  // upadte the dog profile details
  Future<bool> updateDogProfile({
    required String dogId,
    required String newName,
    required String newBreed,
    required String newAge,
    required String newGender,
    required String newLocation,
    String? newHealthConditions,
  }) async {
    emit(DogProfileLoading());
    try {
      // final List<DogEntity> allDogs = await dogProfileRepo.fetchDogProfiles();
      // final currentDog = allDogs.firstWhere(
      //   (dog) => dog.dogId == dogId,
      //   orElse: () => throw Exception('Dog Profile not found'),
      // );
      final updatedDog = await dogProfileRepo.updateDogProfile(
        dogId: dogId,
        name: newName,
        age: newAge,
        breed: newBreed,
        gender: newGender,
        location: newLocation,
        healthConditions: newHealthConditions,
      );
      if (updatedDog == true) {
        await fetchDogProfiles();
        return true;
      } else {
        emit(DogProfileError("Failed to update dog profile details."));
        return false;
      }
    } catch (e) {
      DogProfileError(e.toString());
      return false;
    }
  }

  // update the dog profile image
  Future<bool> updateDogProfileImage(File file, String dogId) async {
    emit(DogProfileLoading());
    try {
      final updatedDog = await dogProfileRepo.updateDogProfileImage(
        profileImage: file,
        dogId: dogId,
      );

      if (updatedDog == true) {
        await fetchDogProfiles();
        return true;
      } else {
        emit(DogProfileError("Failed to update dog profile image."));
        return false;
      }
    } catch (e) {
      emit(DogProfileError(e.toString()));
      return false;
    }
  }

  // add new dog profile
  Future<bool> addNewDogProfile({
    // required String dogId,
    required File profileImage,
    required String name,
    required String age,
    required String breed,
    required String gender,
    required String location,
    String? healthConditions,
  }) async {
    emit(DogProfileLoading());
    try {
      final newDog = await dogProfileRepo.addNewDogProfile(
        profileImage: profileImage,
        name: name,
        age: age,
        breed: breed,
        gender: gender,
        location: location,
        healthConditions: healthConditions,
      );
      if (newDog == true) {
        await fetchDogProfiles();
        return true;
      } else {
        emit(DogProfileError("Failed to add new dog profile."));
        return false;
      }
    } catch (e) {
      DogProfileError(e.toString());
      return false;
    }
  }

  Future<void> deleteDogProfile(String dogId) async {
    emit(DogProfileLoading());
    try {
      await dogProfileRepo.deleteDogProfile(dogId);
      await fetchDogProfiles();
    } catch (e) {
      DogProfileError(e.toString());
    }
  }
}
