import 'package:furrpal/features/profiles/post/domain/models/post_entity.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostEntity> postEntity;
  PostLoaded(this.postEntity);
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}
