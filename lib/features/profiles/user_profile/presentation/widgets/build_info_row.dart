import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/text_custom.dart';

Widget buildInfoRow(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 16.h, color: Colors.grey),
      SizedBox(width: 8.w),
      TextCustomWidget(
        text: text,
        textColor: blackColor,
        fontSize: 16.sp,
      ),
    ],
  );
}
