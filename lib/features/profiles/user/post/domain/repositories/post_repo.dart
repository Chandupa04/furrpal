import 'package:furrpal/features/profiles/user/post/domain/models/post_entity.dart';

abstract class PostRepo {
  Future<List<PostEntity>> fetchUserPost();
}
