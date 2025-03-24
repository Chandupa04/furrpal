import 'package:flutter/material.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/features/profiles/post/domain/models/comment_entity.dart';
import 'package:furrpal/features/profiles/post/presentation/widgets/profile_comment_card.dart';

class ProfileCommentPage extends StatelessWidget {
  final List<CommentEntity> comments;
  const ProfileCommentPage({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return ProfileCommentCard(
            imageUrl: comment.profilePicture ?? '',
            name: comment.name,
            comment: comment.content,
          );
        },
      ),
    );
  }
}
