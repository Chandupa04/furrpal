import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a community post
  Future<void> createCommunityPost({
    required String caption,
    required File? imageFile,
  }) async {
    User? user = _auth.currentUser;
    if (user == null) {
      log('Error: No user logged in');
      throw Exception('No user logged in');
    }

    String userId = user.uid;
    log('Creating community post for user: $userId');

    try {
      DocumentReference reference = _firestore
          .collection('users')
          .doc(userId)
          .collection('community')
          .doc();
      String communityPostId = reference.id;

      String? imageUrl;
      if (imageFile != null) {
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
        final storageRef =
            _storage.ref().child('community_posts/$userId/$fileName');

        try {
          final snapshot = await storageRef.putFile(imageFile);
          imageUrl = await snapshot.ref.getDownloadURL();
        } catch (e) {
          log('Error uploading image: $e');
          throw Exception('Failed to upload image: $e');
        }
      }

      final postData = {
        'post_id': communityPostId,
        'createdAt': FieldValue.serverTimestamp(),
        'caption': caption,
        'imageUrl': imageUrl ?? '',
        'likes': [],
        'comments': [],
        'reports': [],
      };

      await reference.set(postData);
      log('Community post created successfully with ID: $communityPostId');
    } catch (e) {
      log('Error creating community post: $e');
      rethrow;
    }
  }

// Fetch all community posts
  Future<List<Map<String, dynamic>>> getAllCommunityPosts() async {
    try {
      final QuerySnapshot usersSnapshot =
          await _firestore.collection('users').get();

      List<Map<String, dynamic>> posts = [];
      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final String fullName =
            "${userData['first name']} ${userData['last name']}";

        final QuerySnapshot communityPostsSnapshot = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('community')
            .get();

        for (var postDoc in communityPostsSnapshot.docs) {
          final postData = postDoc.data() as Map<String, dynamic>;

          // Format createdAt timestamp to a readable date
          final Timestamp? createdAt = postData['createdAt'] as Timestamp?;
          final formattedDate = createdAt != null
              ? DateFormat('MM/dd/yyyy').format(createdAt.toDate())
              : 'Unknown Date';

          posts.add({
            ...postData,
            'name': fullName,
            'date': formattedDate,
            'profilePictureUrl': userData['profileImageUrl'],
            'postOwnerId': userDoc.id,
          });
        }
      }

      // Sort posts by 'createdAt' in descending order (latest first)
      posts.sort((a, b) {
        final aDate = a['createdAt'] as Timestamp?;
        final bDate = b['createdAt'] as Timestamp?;
        return (bDate?.toDate() ?? DateTime(0))
            .compareTo(aDate?.toDate() ?? DateTime(0));
      });

      return posts;
    } catch (e) {
      log('Error getting community posts: $e');
      return [];
    }
  }

// like community posts
  Future<void> likePost({
    required String postId,
    required String postOwnerId,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        log('Error: No user logged in');
        throw Exception('No user logged in');
      }

      String userId = user.uid;

      final QuerySnapshot usersSnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: userId)
          .get();

      final postRef = _firestore
          .collection('users')
          .doc(postOwnerId)
          .collection('community')
          .doc(postId);

      final postSnapshot = await postRef.get();

      if (!postSnapshot.exists) {
        log('Post not found.');
        return;
      }

      final postData = postSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> likes = postData['likes'] ?? [];

      // Check if the user already liked the post
      final userIndex = likes.indexWhere((like) => like['userId'] == userId);

      if (userIndex != -1) {
        // User already liked the post, remove the like
        likes.removeAt(userIndex);
      } else {
        final userData = usersSnapshot.docs[0].data() as Map<String, dynamic>;
        // Add the user's ID and name to the likes array
        likes.add({
          'userId': userId,
          'userName': userData['first name'] + userData['last name'],
        });
      }

      // Update the post with the new likes array and like count
      await postRef.update({
        'likes': likes,
      });

      log('Post successfully updated with new like count: ${likes.length}');
    } catch (e) {
      log('Error liking the post: $e');
    }
  }

// like community posts
  Future<void> commentPost({
    required String postId,
    required String postOwnerId,
    required String content,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        log('Error: No user logged in');
        throw Exception('No user logged in');
      }

      String userId = user.uid;

      final QuerySnapshot usersSnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: userId)
          .get();

      final postRef = _firestore
          .collection('users')
          .doc(postOwnerId)
          .collection('community')
          .doc(postId);

      final postSnapshot = await postRef.get();

      if (!postSnapshot.exists) {
        log('Post not found.');
        return;
      }

      final postData = postSnapshot.data() as Map<String, dynamic>;

      final List<dynamic> comments = postData['comments'] ?? [];

      final userData = usersSnapshot.docs[0].data() as Map<String, dynamic>;
      comments.add({
        'userId': userId,
        'name': userData['first name'] + " " + userData['last name'],
        'content': content,
        'profilePicture': userData['profileImageUrl']
      });

      await postRef.update({
        'comments': comments,
      });

      log('Post successfully updated with new comment count: ${comments.length}');
    } catch (e) {
      log('Error liking the post: $e');
    }
  }

// like community posts
  Future<void> deleteComment({
    required String postId,
    required String postOwnerId,
    required List<Map<String, dynamic>> comments,
    required int index,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        log('Error: No user logged in');
        throw Exception('No user logged in');
      }

      final postRef = _firestore
          .collection('users')
          .doc(postOwnerId)
          .collection('community')
          .doc(postId);

      final postSnapshot = await postRef.get();

      if (!postSnapshot.exists) {
        log('Post not found.');
        return;
      }

      comments.removeAt(index);

      await postRef.update({
        'comments': comments,
      });

      log('Post successfully updated with new comment count: ${comments.length}');
    } catch (e) {
      log('Error liking the post: $e');
    }
  }

  Future<void> deletePost(
      {required String postOwnerId, required String postId}) async {
    try {
      await _firestore
          .collection('users')
          .doc(postOwnerId)
          .collection('community')
          .doc(postId)
          .delete();
      print('Post deleted successfully');
    } catch (e) {
      print('Error deleting post: $e');
      throw Exception('Failed to delete post');
    }
  }

// like community posts
  Future<void> reportPost({
    required String postId,
    required String postOwnerId,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        log('Error: No user logged in');
        throw Exception('No user logged in');
      }

      final postRef = _firestore
          .collection('users')
          .doc(postOwnerId)
          .collection('community')
          .doc(postId);

      final postSnapshot = await postRef.get();

      if (!postSnapshot.exists) {
        log('Post not found.');
        return;
      }

      final postData = postSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> reports = postData['reports'] ?? [];

      if (reports.contains(user.uid)) {
        print('User has already reported this post');
      } else {
        reports.add(user.uid);
        await postRef.update({
          'reports': reports,
        });
        log('Post successfully updated with new report count: ${reports.length}');
      }

      if (reports.length > 20) {
        await deletePost(postId: postId, postOwnerId: postOwnerId);
        log('Post successfully deleted');
      }
    } catch (e) {
      log('Error reporting the post: $e');
    }
  }

  Future<void> editPost({
    required String postId,
    required String newContent,
  }) async {
    User? user = _auth.currentUser;
    if (user == null) {
      log('Error: No user logged in');
      throw Exception('No user logged in');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('community')
        .doc(postId)
        .update({
      'caption': newContent,
      'editedAt': Timestamp.now(),
    });

            log('Post successfully updated');

  }
}
