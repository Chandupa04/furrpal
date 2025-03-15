import 'package:email_validator/email_validator.dart';
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
  bool isValid = false;

  void login() {
    isValid = EmailValidator.validate(emailController.text.trim());
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: blackColor,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r))),
          content: TextCustomWidget(
            text: 'Email is not valid',
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return;
    }

    final String email = emailController.text;
    final String password = passwordController.text;
    final authCubit = context.read<AuthCubit>();
    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        inProgress = true;
      });
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextCustomWidget(
            text: 'Please Enter Both Email and Password',
            fontSize: 17.sp,
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
        if (state is AuthError) {
          setState(() {
            inProgress = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: blackColor,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r))),
              content: TextCustomWidget(
                text: 'The email or password is incorrect',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const NavBar()), // Show NavBar after login
          );
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
                      obscureText: true,
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
                                builder: (context) => const SignupPage(),
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
