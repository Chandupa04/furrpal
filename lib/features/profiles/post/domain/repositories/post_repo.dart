import 'package:furrpal/features/profiles/post/domain/models/post_entity.dart';

abstract class PostRepo {
  Stream<List<PostEntity>> fetchUserPost();
}
