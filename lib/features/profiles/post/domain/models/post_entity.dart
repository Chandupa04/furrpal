import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furrpal/features/profiles/post/domain/models/comment_entity.dart';

class PostEntity {
  final String postId;
  final String imageUrl;
  final String caption;
  final List likes;
  final List<CommentEntity> comments;
  final Timestamp? createdAt;
  PostEntity({
    required this.postId,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    this.createdAt,
  });
  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      postId: json['post_id'],
      imageUrl: json['imageUrl'],
      caption: json['caption'],
      likes: json['likes'] ?? [],
      comments: json['comments'] != null
          ? (json['comments'] as List)
              .map((comment) => CommentEntity.fromJson(comment))
              .toList()
          : [],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
    };
  }
}
