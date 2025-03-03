import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_state.dart';
import 'package:furrpal/features/auth/presentation/pages/start_page.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  void logout() {
    final authCubit = context.read<AuthCubit>();
    authCubit.logout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => StartPage(),
              ),
              (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false,),
        body: Column(
          children: [
            ButtonCustom(
              isLoading: false,
              text: 'Logout',
              callback: logout,
            )
          ],
        ),
      ),
    );
  }
}
