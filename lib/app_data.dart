import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/config/firebase_auth_repo.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_state.dart';
import 'package:furrpal/features/nav_bar/presentation/pages/nav_bar.dart';
import 'custom/text_custom.dart';
import 'features/auth/presentation/pages/start_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepo = FirebaseAuthRepo();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(452, 778),
      child: BlocProvider(
        create: (context) =>
            AuthCubit(authRepo: authRepo)..checkUserAuthentication(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            scaffoldBackgroundColor: whiteColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: whiteColor,
              foregroundColor: blackColor,
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
                return NavBar();
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
                print(state.message);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: TextCustomWidget(text: state.message)));
              }
            },
          ),
        ),
      ),
    );
    // );
  }
}
