import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/config/firebase_auth_repo.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_state.dart';
import 'package:furrpal/features/nav_bar/presentation/pages/nav_bar.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/cubit/dog_profile_cubit.dart';
import 'package:furrpal/features/profiles/user_profile/data/firebase_user_profile_repo.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/cubit/profile_cubit.dart';
import 'package:furrpal/features/profiles/user_profile/user_profile_picture/data/firebase_profile_picture_repo.dart';
import 'custom/text_custom.dart';
import 'features/auth/presentation/pages/start_page.dart';
import 'features/profiles/dog_profile/data/firebase_dog_profile_repo.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  // profile repo
  final firebaseProfileRepo = FirebaseUserProfileRepo();

  // profile image repo
  final firebasePictureRepo = FirebaseProfilePictureRepo();

  final firebasedogProfileRepo = FirebaseDogProfileRepo();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(452, 778),
        child: MultiBlocProvider(
          providers: [
            // auth cubit
            BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(authRepo: firebaseAuthRepo)
                ..checkUserAuthentication(),
            ),

            //profile cubit
            BlocProvider<ProfileCubit>(
              create: (context) => ProfileCubit(
                  profileRepo: firebaseProfileRepo,
                  pictureRepo: firebasePictureRepo),
            ),

            // dog profile cubit
            BlocProvider<DogProfileCubit>(
              create: (context) => DogProfileCubit(
                dogProfileRepo: firebasedogProfileRepo,
              ),
            ),
          ],
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
            home: BlocBuilder<AuthCubit, AuthState>(
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
              // listener: (context, state) {
              //   if (state is AuthError) {
              //     print(state.message);
              //     ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(content: TextCustomWidget(text: state.message)));
              //   }
              // },
            ),
          ),
        ));
    // );
  }
}
