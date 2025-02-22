import 'package:custom_check_box/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/custom/container_custom.dart';

import '../../../../custom/text_custom.dart';
import '../../../../custom/textfield_custom.dart';
import 'package:furrpal/features/auth/presentation/pages/userprofile_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isobscutured = false;
  bool isChecked = false;

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
              height: 549.h,
              marginLeft: 13.w,
              marginRight: 13.w,
              paddingLeft: 23.w,
              paddingRight: 23.w,
              paddingTop: 24.h,
              paddingBottom: 24.h,
              borderRadius: BorderRadius.circular(16.r),
              gradient: primaryGradient,
              child: Column(
                children: [
                  TextCustomWidget(
                    text: 'First Name',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    marginBottom: 15.h,
                  ),
                  TextCustomWidget(
                    text: 'Last Name',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    marginBottom: 15.h,
                  ),
                  TextCustomWidget(
                    text: 'Email',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    keyboardType: TextInputType.emailAddress,
                    marginBottom: 15.h,
                  ),
                  TextCustomWidget(
                    text: 'Password',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    marginBottom: 19.h,
                    obscureText: isobscutured,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isobscutured = !isobscutured;
                        });
                      },
                      icon: ImageIcon(
                        AssetImage(
                          isobscutured == true
                              ? 'assets/icons/password_hide.png'
                              : 'assets/icons/password_unhide.png',
                        ),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomCheckBox(
                        borderColor: primaryColor,
                        checkedFillColor: primaryColor,
                        value: isChecked,
                        onChanged: (index) {
                          setState(() {
                            isChecked = index;
                          });
                        },
                      ),
                      TextCustomWidget(
                        text: 'Agree with Terms & Conditions',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  ButtonCustom(
                    text: 'Creat Account',
                    callback: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UserProfileScreen()));

                    },
                    isDisabled: isChecked == false ? true : false,
                    dontApplyMargin: true,
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
