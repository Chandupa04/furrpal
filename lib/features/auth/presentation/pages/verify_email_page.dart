import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furrpal/app_data.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/pages/dog_profile_creat_page.dart';
import 'package:furrpal/features/auth/presentation/pages/start_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isEmailVerified = false;

  void logout() {}
  // Timer? timer;

  // @override
  // void initState() {
  //   super.initState();
  //   // timer = Timer.periodic(
  //   //   Duration(seconds: 3),
  //   //   (_) => checkEmailVerified(),
  //   // );
  // }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  // Future checkEmailVerified() async {
  //   await currentUser!.reload();
  //   // final updatedUser = FirebaseAuth.instance.currentUser;

  //   setState(() {
  //     isEmailVerified = currentUser!.emailVerified;
  //   });
  // if (isEmailVerified)
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => DogProfileCreatPage(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Verify Email',
            style: appBarStyle,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentUser != null)
              TextCustomWidget(
                text: 'Please verify your email ${currentUser!.email}',
                textColor: blackColor,
              ),
            // ButtonCustom(
            //   text: 'continue',
            //   callback: () {
            //     checkEmailVerified();
            //   },
            // ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  final authCubit = context.read<AuthCubit>();
                  authCubit.logout();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartPage(),
                      ),
                      (route) => false);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
      );
}
