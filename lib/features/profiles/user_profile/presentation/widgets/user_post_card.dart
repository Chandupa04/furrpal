import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/profiles/user/post/domain/models/post_entity.dart';
import 'package:intl/intl.dart';

class UserPostCard extends StatelessWidget {
  final PostEntity post;
  const UserPostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerCustom(
      paddingBottom: 5.h,
      paddingLeft: 5.w,
      paddingRight: 5.w,
      paddingTop: 5.h,
      bgColor: postColor,
      margin: EdgeInsets.symmetric(vertical: 5.h),
      shadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 2.h),
          blurRadius: 5.r,
        ),
      ],
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: post.imageUrl,
            placeholder: (context, url) => ContainerCustom(
                width: 200.w,
                height: 100.h,
                child: const CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(
              Icons.photo,
              size: 72.h,
              color: Colors.blue,
            ),
            imageBuilder: (context, imageProvider) => ContainerCustom(
              width: double.infinity.w,
              height: MediaQuery.of(context).size.height * 0.3.h,
              borderRadius: BorderRadius.circular(8.r),
              clipBehavior: Clip.hardEdge,
              decorationImage: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          TextCustomWidget(
            text: DateFormat('dd/MM/yyyy').format(post.timeStamp!.toDate()),
            textColor: blackColor,
            fontSize: 14.sp,
            marginLeft: 10.w,
            marginTop: 4.h,
          ),
          TextCustomWidget(
            text: post.caption,
            fontSize: 16.sp,
            marginLeft: 10.w,
            marginTop: 4.h,
            textColor: blackColor,
          ),
        ],
      ),
    );
  }
}
