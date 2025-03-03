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
  String _postContent = "This is a sample post content."; // Dummy content
  bool _isEditing = false;

  void _editPost() {
    TextEditingController _editController = TextEditingController(text: _postContent);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Post"),
          content: TextField(
            controller: _editController,
            maxLines: 4,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _postContent = _editController.text;
                  _isEditing = false;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

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
                  CircleAvatar(radius: 24.r),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustomWidget(
                        text: 'Name',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        marginLeft: 10.w,
                      ),
                      TextCustomWidget(
                        text: '2/25/2025',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        marginLeft: 10.w,
                      ),
                    ],
                  ),
                ],
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.black),
                color: Colors.white,
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
                    child: TextCustomWidget(
                      text: "Edit",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      textColor: blackColor,
                    ),
                    onTap: _editPost,
                  ),
                  PopupMenuItem(
                    value: "Delete",
                    height: 30.h,
                    child: TextCustomWidget(
                      text: "Delete",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      textColor: blackColor,
                    ),
                    onTap: () {
                      // Handle delete logic here
                    },
                  ),
                ],
              ),
            ],
          ),
          ContainerCustom(
            marginTop: 10.h,
            marginBottom: 10.h,
            child: TextCustomWidget(
              text: _postContent,
              fontSize: 16.sp,
            ),
          ),
          ContainerCustom(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            bgColor: Colors.grey,
          ),
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border_rounded),
                    color: Colors.black,
                  ),
                  TextCustomWidget(
                    text: '1',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    marginLeft: 5.w,
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(),
                        ),
                      );
                    },
                    icon: const Icon(LucideIcons.messageCircle),
                    color: Colors.black,
                  ),
                  TextCustomWidget(
                    text: '1',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    marginLeft: 5.w,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
