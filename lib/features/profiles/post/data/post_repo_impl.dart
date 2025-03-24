import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furrpal/features/profiles/post/domain/models/post_entity.dart';
import 'package:furrpal/features/profiles/post/domain/repositories/post_repo.dart';

class PostRepoImpl implements PostRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Future<List<PostEntity>> fetchUserPost() async {
    try {
      final postDoc = await firebaseFirestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('community')
          .get();

      return postDoc.docs.map((doc) {
        final postData = doc.data();
        return PostEntity.fromJson(postData);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
