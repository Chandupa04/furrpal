import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
  final String postId;
  final String imageUrl;
  final String caption;
  final int likesCount;
  final List comments;
  final Timestamp? timeStamp;
  PostEntity({
    required this.postId,
    required this.imageUrl,
    required this.caption,
    required this.likesCount,
    required this.comments,
    this.timeStamp,
  });
  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      postId: json['post_id'],
      imageUrl: json['imageUrl'],
      caption: json['caption'],
      likesCount: json['likesCount'],
      comments:
          json['comments'] != null ? List<String>.from(json['comments']) : [],
      timeStamp: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'imageUrl': imageUrl,
      'caption': caption,
      'likesCount': likesCount,
      'comments': comments,
      'createdAt': timeStamp,
    };
  }
}
