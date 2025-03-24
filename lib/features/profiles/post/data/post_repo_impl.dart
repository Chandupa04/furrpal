import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furrpal/features/profiles/post/domain/models/post_entity.dart';
import 'package:furrpal/features/profiles/post/domain/repositories/post_repo.dart';

class PostRepoImpl implements PostRepo {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Stream<List<PostEntity>> fetchUserPost() {
    try {
      return firebaseFirestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('community')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final postData = doc.data();
          return PostEntity.fromJson(postData);
        }).toList();
      });
    } catch (e) {
      print(e);
      return Stream.empty();
    }
  }
}
