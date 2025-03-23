import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/community/presentation/pages/comment_page.dart';
import 'package:furrpal/features/community/presentation/pages/community_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CommunityPostCard extends StatefulWidget {
  final String name;
  final String profilePictureUrl;
  final String imageUrl;
  final String date;
  final String caption;
  final String postOwnerId;
  final String postId;
  final List<Map<String, dynamic>> comments;
  final List<Map<String, dynamic>> likes;
  final Function onPostDeleted;

  const CommunityPostCard({
    super.key,
    required this.name,
    required this.profilePictureUrl,
    required this.date,
    required this.imageUrl,
    required this.caption,
    required this.postOwnerId,
    required this.postId,
    required this.comments,
    required this.likes,
    required this.onPostDeleted,
  });

  @override
  _CommunityPostCardState createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  bool isLiked = false;
  late int currentLikes;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentLikes = widget.likes.length;
    currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Check if the current user has already liked the post
    isLiked = widget.likes.any((like) => like['userId'] == currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return ContainerCustom(
      marginLeft: 10.w,
      marginRight: 10.w,
      marginBottom: 10.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundImage: widget.profilePictureUrl.isNotEmpty
                        ? NetworkImage(widget.profilePictureUrl)
                        : const AssetImage('assets/icons/user_profile.png')
                            as ImageProvider,
                    onBackgroundImageError: (_, __) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustomWidget(
                        text: widget.name,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        marginLeft: 10.w,
                        textColor: blackColor,
                      ),
                      TextCustomWidget(
                        text: widget.date,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        marginLeft: 10.w,
                        textColor: blackColor,
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (currentUserId == widget.postOwnerId) ...[
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit Post'),
                              onTap: () {
                                // Handle Edit
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete Post'),
                              onTap: () async {
                                final confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Post'),
                                    content: const Text(
                                        'Are you sure you want to delete this post?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context,
                                            false), // Cancel the dialog
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context,
                                              true); // Confirm deletion and close the dialog
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmDelete == true) {
                                  await CommunityService().deletePost(
                                    postOwnerId: widget.postOwnerId,
                                    postId: widget.postId,
                                  );

                                  // Close the dialog and perform any necessary state updates
                                  Navigator.of(context)
                                      .pop(); // Close the current screen if needed (optional)

                                  // Call the callback to refresh the posts on the parent page
                                  widget.onPostDeleted();
                                }
                              },
                            ),
                          ],
                          if (currentUserId != widget.postOwnerId) ...[
                            ListTile(
                              leading: const Icon(Icons.report),
                              title: const Text('Report Post'),
                              onTap: () {
                                // Handle Report
                              },
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          ContainerCustom(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            marginTop: 10.h,
            marginBottom: 10.h,
            child: Image.network(
              widget.imageUrl,
              height: 250.h,
              fit: BoxFit.contain,
            ),
          ),
          TextCustomWidget(
            text: widget.caption,
            textColor: blackColor,
          ),
          Row(
            children: [
              // Like Button
              Row(
                children: [
                  ContainerCustom(
                    width: 30.w,
                    height: 30.h,
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          if (isLiked) {
                            currentLikes -= 1;
                          } else {
                            currentLikes += 1;
                          }
                          isLiked = !isLiked;
                        });

                        // Update like status in Firestore
                        await CommunityService().likePost(
                            postId: widget.postId,
                            postOwnerId: widget.postOwnerId);
                      },
                      padding: EdgeInsets.zero,
                      icon: Icon(isLiked
                          ? Icons.favorite
                          : Icons.favorite_border_rounded),
                      color: isLiked ? Colors.red : null,
                    ),
                  ),
                  TextCustomWidget(
                    text: '$currentLikes',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    marginLeft: 5.w,
                    textColor: blackColor,
                  ),
                ],
              ),
              // Comment Button
              Row(
                children: [
                  ContainerCustom(
                    width: 30.w,
                    height: 30.h,
                    marginLeft: 30.w,
                    child: IconButton(
                      onPressed: () {
                        // Navigate to the CommentPage with comments
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(
                              comments: widget.comments,
                              postId: widget.postId,
                              postOwnerId: widget.postOwnerId,
                              onCommentAdd: widget.onPostDeleted,
                            ),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(LucideIcons.messageCircle),
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  TextCustomWidget(
                    text: '${widget.comments.length}',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    marginLeft: 5.w,
                    textColor: blackColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
