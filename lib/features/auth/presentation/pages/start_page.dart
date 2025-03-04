import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/auth/presentation/pages/login_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContainerCustom(
        gradient: primaryGradient,
        child: Column(
          children: [
            TextCustomWidget(
              text: 'Find Your Dog’s Perfect Match!',
              fontSize: 25.sp,
              fontWeight: FontWeight.w700,
              marginTop: 194.h,
              containerAlignment: Alignment.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextCustomWidget(
                  text: 'Love Awaits',
                  fontSize: 25.sp,
                  containerAlignment: Alignment.center,
                ),
                Image.asset('assets/icons/dog_foot.png')
              ],
            ),
            Image.asset(
              logoImage,
              width: 352.w,
              height: 352.h,
            ),
            ButtonCustom(
              // isLoading: false,
              text: "Let's Match",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
