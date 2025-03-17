import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/community/presentation/pages/comment_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CommunityPostCard extends StatefulWidget {
  const CommunityPostCard({super.key});

  @override
  _CommunityPostCardState createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  String _postContent = 'Original post content here'; // Initial post content
  final TextEditingController _editController = TextEditingController();

  void _editPost() {
    // Set initial value of controller to the current post content
    _editController.text = _postContent;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: TextField(
            controller: _editController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Edit your post...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _postContent = _editController.text;
                });
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _hidePost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hide Post?"),
          content: const Text("Are you sure you want to hide this post?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle hide logic here (e.g., change state to hide the post)
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Post hidden')));
              },
              child: const Text("Hide"),
            ),
          ],
        );
      },
    );
  }

  void _reportPost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Report Post?"),
          content: const Text("Are you sure you want to report this post?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle report logic here (e.g., send report to the backend)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post reported')));
              },
              child: const Text("Report"),
            ),
          ],
        );
      },
    );
  }

  void _deletePost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Post?"),
          content: const Text(
              "Are you sure you want to delete this post? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle delete logic here (e.g., remove the post from the list)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post deleted')));
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return ContainerCustom(
      marginLeft: 10.w,
      marginRight: 10.w,
      marginBottom: 10.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustomWidget(
                        text: 'Name',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        marginLeft: 10.w,
                        textColor: blackColor,
                      ),
                      TextCustomWidget(
                        text: '2/25/2025',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        marginLeft: 10.w,
                        textColor: blackColor,
                      ),
                    ],
                  ),
                ],
              ),
              ContainerCustom(
                child: PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  padding: EdgeInsets.zero,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      bottomLeft: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                    ),
                  ),
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "Edit",
                      height: 30.h,
                      onTap: _editPost,
                      child: TextCustomWidget(
                        text: "Edit",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        textColor: blackColor,
                      ),
                    ),
                    PopupMenuItem(
                      value: "Delete",
                      height: 30.h,
                      onTap: _deletePost,
                      child: TextCustomWidget(
                        text: "Delete",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        textColor: blackColor,
                      ), // Show delete confirmation dialog
                    ),
                    PopupMenuItem(
                      value: "Hide",
                      height: 30.h,
                      onTap: _hidePost,
                      child: TextCustomWidget(
                        text: "Hide",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        textColor: blackColor,
                      ), // Show hide dialog
                    ),
                    PopupMenuItem(
                      value: "Report",
                      height: 30.h,
                      onTap: _reportPost,
                      child: TextCustomWidget(
                        text: "Report",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        textColor: blackColor,
                      ), // Show report dialog
                    ),
                  ],
                ),
              ),
            ],
          ),
          ContainerCustom(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Image.asset('assets/images/gallery.jpeg',
            height: 250.h,
            fit: BoxFit.contain,
            ),
            width: double.infinity,
            marginTop: 10.h,
            marginBottom: 10.h,
            // bgColor: Colors.grey,
          ),
          TextCustomWidget(
            text: _postContent,
            textColor: blackColor,
          ),
          TextCustomWidget(
            text: _postContent, // Display the current post content
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            marginLeft: 10.w,
            marginRight: 10.w,
          ),
          Row(
            children: [
              Row(
                children: [
                  ContainerCustom(
                    width: 30.w,
                    height: 30.h,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                      padding: EdgeInsets.zero,
                      icon: Icon(isLiked == true
                          ? Icons.favorite
                          : Icons.favorite_border_rounded),
                      color: isLiked == true ? Colors.red : null,
                    ),
                  ),
                  TextCustomWidget(
                    text: '1',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    marginLeft: 5.w,
                    textColor: blackColor,
                  ),
                ],
              ),
              Row(
                children: [
                  ContainerCustom(
                    width: 30.w,
                    height: 30.h,
                    marginLeft: 30.w,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CommentPage(),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(LucideIcons.messageCircle),
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  TextCustomWidget(
                    text: '1',
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