import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/auth/data/repositories/firebase_auth_repo.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_state.dart';
import 'package:furrpal/features/nav_bar/presentation/pages/nav_bar.dart';
import 'features/auth/presentation/pages/start_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepo = FirebaseAuthRepo();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthCubit(authRepo: authRepo)..checkUserAuthentication(),
      child: ScreenUtilInit(
        designSize: const Size(452, 778),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            scaffoldBackgroundColor: blackColor,
            appBarTheme: AppBarTheme(
              backgroundColor: blackColor,
              foregroundColor: whiteColor,
            ),
            useMaterial3: true,
          ),
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, authState) {
              print(authState);

              if (authState is UnAuthenticated) {
                return const StartPage();
              }
              if (authState is Authenticated) {
                return const NavBar();
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: TextCustomWidget(text: state.message)));
              }
            },
          ),
        ),
      ),
    );
  }
}
