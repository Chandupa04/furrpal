import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:furrpal/features/profiles/post/domain/models/post_entity.dart';
import 'package:furrpal/features/profiles/post/domain/repositories/post_repo.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  StreamSubscription<List<PostEntity>>? postSubscription;
  PostCubit({required this.postRepo}) : super(PostInitial());

  void fetchUserPost() {
    emit(PostLoading());
    postSubscription?.cancel();
    postSubscription = postRepo.fetchUserPost().listen((currentUserPosts) {
      print('list is $currentUserPosts');
      emit(PostLoaded(currentUserPosts));
    }, onError: (error) {
      emit(PostError(error.toString()));
    });
    // final List<PostEntity> currentUserPosts = await postRepo.fetchUserPost();
    // print('list is $currentUserPosts');
  }

  @override
  Future<void> close() {
    postSubscription?.cancel();
    return super.close();
  }
}
