import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import '../../../../custom/container_custom.dart';
import '../../../../custom/text_custom.dart';
import '../../../../custom/textfield_custom.dart';



class DogProfileCreatPage extends StatelessWidget {
  const DogProfileCreatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
      ),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              logoImage,
              width: 150.w,
              height: 150.h,
            ),
            ContainerCustom(
              marginLeft: 13.w,
              marginRight: 13.w,
              marginBottom: 10.h,
              paddingLeft: 23.w,
              paddingRight: 23.w,
              paddingTop: 24.h,
              paddingBottom: 24.h,
              borderRadius: BorderRadius.circular(16.r),
              gradient: primaryGradient,
              child: Column(
                children: [
                  TextCustomWidget(
                    text: "Dog's Name",
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    marginBottom: 15.h,
                  ),
                  TextCustomWidget(
                    text: 'Breed',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    marginBottom: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustomWidget(
                            text: 'Gender',
                            fontSize: 17.sp,
                            marginLeft: 9.w,
                            marginBottom: 4.h,
                          ),
                          TextFieldCustom(
                            width: 151.w,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustomWidget(
                            text: 'Age',
                            fontSize: 17.sp,
                            marginLeft: 9.w,
                            marginBottom: 4.h,
                          ),
                          TextFieldCustom(
                            width: 151.w,
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextCustomWidget(
                    text: 'Health Conditions',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                    marginTop: 15.h,
                  ),
                  TextFieldCustom(
                    keyboardType: TextInputType.emailAddress,
                    marginBottom: 15.h,
                  ),
                  TextCustomWidget(
                    text: 'Location of the pet',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    marginBottom: 27.h,
                  ),
                  ButtonCustom(
                    text: 'Create Account',
                    dontApplyMargin: true,
                    callback: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
