import 'package:furrpal/features/profiles/dog_profile/domain/models/dog_entity.dart';

abstract class DogProfileState {}

//initial
class DogProfileInitial extends DogProfileState {}

//loading
class DogProfileLoading extends DogProfileState {}

//loaded
class DogProfileLoaded extends DogProfileState {
  final List<DogEntity> dogEntity;
  DogProfileLoaded(this.dogEntity);
}

//error
class DogProfileError extends DogProfileState {
  final String message;
  DogProfileError(this.message);
}
