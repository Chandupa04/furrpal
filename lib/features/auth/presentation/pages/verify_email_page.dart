import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/pages/dog_profile_creat_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          isEmailVerified = user.emailVerified;
          authCubit.verifyEmail();
        });
      } else {
        setState(() {
          isEmailVerified = false;
        });
      }
    });
    // final currentUser = firebaseAuth.currentUser;
    // isEmailVerified = currentUser!.emailVerified;
    // if (!isEmailVerified) {
    //   authCubit.verifyEmail();
    // }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified == true
      ? DogProfileCreatPage()
      : Scaffold(
          appBar: AppBar(
            title: Text(
              'Verify Email',
              style: appBarStyle,
            ),
          ),
        );
}
