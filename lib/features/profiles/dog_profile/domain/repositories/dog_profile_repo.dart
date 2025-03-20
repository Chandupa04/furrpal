import 'package:furrpal/features/profiles/dog_profile/domain/models/dog_entity.dart';

abstract class DogProfileRepo {
  Future<List<DogEntity>> fetchDogProfiles();
  Future<void> updateDogProfile(DogEntity updateProfile);
}
