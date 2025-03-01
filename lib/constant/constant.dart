import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color primaryColor = Color(0xffFDA283);
const Color whiteColor = Color(0xffFFFFFF);
const Color postColor = Color(0xffFFDACD);
const Color blackColor = Color(0xff000000);

const Gradient primaryGradient = LinearGradient(
  colors: [
    Color(0xffFDA283),
    Color(0xffFFDACD),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const String logoImage = 'assets/images/logo.png';

TextStyle appBarStyle = TextStyle(
  fontSize: 22.sp,
  fontWeight: FontWeight.w700,
);
