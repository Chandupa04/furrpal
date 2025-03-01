import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/custom/textfield_custom.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_state.dart';
import 'package:furrpal/features/auth/presentation/pages/signup_page.dart';
import 'package:furrpal/features/nav_bar/presentation/pages/nav_bar.dart';

import '../../../home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isobscutured = false;
  bool inProgress = false;

  void login() {
    setState(() {
      inProgress = true;
    });
    final String email = emailController.text;
    final String password = passwordController.text;
    final authCubit = context.read<AuthCubit>();
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextCustomWidget(
            text: 'Please Enter Both Email and Password',
            fontSize: 12.sp,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          surfaceTintColor: whiteColor,
          backgroundColor: whiteColor,
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
                // width: 376.w,
                height: 397.h,
                marginTop: 112.h,
                marginLeft: 13.w,
                marginRight: 13.w,
                paddingTop: 31.h,
                paddingLeft: 23.w,
                paddingRight: 23.w,
                paddingBottom: 31.h,
                borderRadius: BorderRadius.circular(16.r),
                gradient: primaryGradient,
                child: Column(
                  children: [
                    TextCustomWidget(
                      text: 'Email',
                      fontSize: 17.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    TextFieldCustom(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextCustomWidget(
                      text: 'Password',
                      fontSize: 17.sp,
                      marginTop: 20.h,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    TextFieldCustom(
                      controller: passwordController,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextCustomWidget(
                          text: 'Do not have an account? ',
                          fontSize: 17.sp,
                        ),
                        ButtonCustom(
                          text: 'SignUp',
                          callback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          btnHeight: 22.h,
                          btnColor: Colors.transparent,
                          dontApplyMargin: true,
                          textStyle: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      iconSize: 30.h,
                      icon: Image.asset('assets/icons/google.png'),
                      style: IconButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                          side: const BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    ButtonCustom(
                      text: 'Login to FurrPal',
                      callback: login,
                      inProgress: inProgress,
                      isDisabled: inProgress,
                      disabledColor: primaryColor,
                      // () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => NavBar(),
                      //     ),
                      //   );
                      // },
                      dontApplyMargin: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
