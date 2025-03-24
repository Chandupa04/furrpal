import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';

class ProfileCommentCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String comment;
  const ProfileCommentCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerCustom(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      marginTop: 10.h,
      marginLeft: 20.w,
      marginRight: 20.w,
      borderRadius: BorderRadius.only(
        // topLeft: Radius.circular(10.r),
        topRight: Radius.circular(15.r),
        bottomRight: Radius.circular(15.r),
        bottomLeft: Radius.circular(15.r),
      ),
      bgColor: postColor,
      shadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(4.w, 2.h),
          blurRadius: 5.r,
        ),
      ],
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => ContainerCustom(
              width: 50.w,
              height: 50.h,
              child: const CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => ContainerCustom(
              width: 50.w,
              height: 50.h,
              shape: BoxShape.circle,
              bgColor: Colors.black,
              child: Icon(
                Icons.person,
                size: 35.h,
                color: Colors.grey,
              ),
            ),
            imageBuilder: (context, imageProvider) => ContainerCustom(
              width: 50.w,
              height: 50.h,
              shape: BoxShape.circle,
              decorationImage: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextCustomWidget(
                text: name,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                textColor: blackColor,
                marginLeft: 15.w,
              ),
              TextCustomWidget(
                text: comment,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                textColor: blackColor,
                marginLeft: 15.w,
              )
            ],
          ),
        ],
      ),
    );
  }
}
