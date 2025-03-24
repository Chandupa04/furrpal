import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/custom/container_custom.dart';

Widget buildInfoRow(IconData icon, String text) {
  return Row(
    children: [
      ContainerCustom(
        padding: EdgeInsets.all(6.w),  // Fixed: Wrapped with EdgeInsets.all()
        bgColor: const Color(0xFFFBA182).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),  // Fixed: Wrapped with BorderRadius.circular()
        child: Icon(
          icon,
          size: 16.sp,
          color: const Color(0xFFFBA182),
        ),
      ),
      SizedBox(width: 10.w),
      Expanded(
        child: TextCustomWidget(
          text: text,
          textColor: blackColor,
          fontSize: 15.sp,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ],
  );
}