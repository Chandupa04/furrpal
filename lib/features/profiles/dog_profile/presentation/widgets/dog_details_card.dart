import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';

Widget dogDetailsCard({
  required IconData icon,
  required String title,
  required String value,
}) {
  return ContainerCustom(
    shadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.6),
        spreadRadius: 1,
        blurRadius: 7,
        offset: Offset(0, 3.h),
      ),
    ],
    padding: EdgeInsets.all(10.w),
    borderRadius: BorderRadius.circular(5.r),
    bgColor: postColor,
    marginLeft: 25.w,
    marginRight: 25.w,
    marginBottom: 20.h,
    child: Row(
      children: [
        ContainerCustom(
          padding: EdgeInsets.all(10.w),
          borderRadius: BorderRadius.circular(5.r),
          bgColor: Colors.grey[200],
          child: Icon(
            icon,
            size: 20.h,
            color: primaryColor,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextCustomWidget(
              text: title,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              textColor: blackColor,
              marginLeft: 10.w,
            ),
            TextCustomWidget(
              marginLeft: 10.w,
              text: value,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              textColor: blackColor,
            ),
          ],
        ),
      ],
    ),
  );
}
