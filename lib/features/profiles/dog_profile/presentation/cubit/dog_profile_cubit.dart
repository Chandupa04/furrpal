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

  // get current dog profile

  // DogEntity? get currentDog => currentDogProfile;
}
