import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerCustom(
      marginLeft: 10.w,
      marginRight: 10.w,
      marginBottom: 10.h,
      // bgColor: postColor,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15.r,
              ),
              TextCustomWidget(
                text: 'Name',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                marginLeft: 10.w,
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
                      icon: Icon(Icons.favorite_border_rounded),
                      color: Colors.black,
                    ),
                  ),
                  TextCustomWidget(
                    text: '1',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
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
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      icon: Icon(LucideIcons.messageCircle),
                      color: Colors.black,
                    ),
                  ),
                  TextCustomWidget(
                    text: '1',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
