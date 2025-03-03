import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/community/presentation/pages/comment_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({super.key});

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
              ContainerCustom(
                // marginRight: 10.w,
                child: PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: whiteColor,
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
                      child: TextCustomWidget(
                        text: "Edit",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        textColor: blackColor,
                      ),
                      onTap: () {},
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
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          ContainerCustom(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            marginTop: 10.h,
            marginBottom: 10.h,
            bgColor: Colors.grey,
          ),
          Row(
            children: [
              Row(
                children: [
                  ContainerCustom(
                    width: 30.w,
                    height: 30.h,
                    child: IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.favorite_border_rounded),
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
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
                  ContainerCustom(
                    width: 30.w,
                    height: 30.h,
                    marginLeft: 30.w,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(),
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
