import 'dart:io';

import 'package:furrpal/features/profiles/dog_profile/domain/models/dog_entity.dart';

abstract class DogProfileRepo {
  Future<List<DogEntity>> fetchDogProfiles();
  Future<bool> updateDogProfile({
    required String dogId,
    required String name,
    required String age,
    required String weightKg,
    required String breed,
    required String gender,
    required String location,
    String? bloodline,
    String? healthReportUrl,
  });
  Future<bool> updateDogProfileImage(
      {required File profileImage, required String dogId});

  Future<bool> addNewDogProfile({
    required String name,
    required String age,
    required String weightKg,
    required String breed,
    required String gender,
    required String location,
    required File profileImage,
    String? bloodline,
    String? healthReportUrl,
  });

  Future<void> deleteDogProfile(String dogId);
}
