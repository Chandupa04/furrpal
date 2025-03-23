import 'package:bloc/bloc.dart';
import 'package:furrpal/features/profiles/user/post/domain/models/post_entity.dart';
import 'package:furrpal/features/profiles/user/post/domain/repositories/post_repo.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  PostCubit({required this.postRepo}) : super(PostInitial());

  Future<void> fetchUserPost() async {
    try {
      emit(PostLoading());
      final List<PostEntity> currentUserPosts = await postRepo.fetchUserPost();
      print('list is $currentUserPosts');
      emit(PostLoaded(currentUserPosts));
    } catch (e) {
      PostError(e.toString());
    }
  }
}
