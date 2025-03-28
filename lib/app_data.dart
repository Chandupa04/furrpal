import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/features/auth/data/auth_repo_impl.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_state.dart';
import 'package:furrpal/features/nav_bar/presentation/pages/nav_bar.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/cubit/dog_profile_cubit.dart';
import 'package:furrpal/features/profiles/user_profile/data/user_profile_repo_impl.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/cubit/profile_cubit.dart';
import 'package:provider/provider.dart';
import 'package:furrpal/features/shop/presentation/pages/cart_provider.dart';
import 'features/auth/presentation/pages/start_page.dart';
import 'features/profiles/dog_profile/data/dog_profile_repo_impl.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Auth repo
  final authRepo = AuthRepoImpl();

  // Profile repo
  final profileRepo = UserProfileRepoImpl();

  // dog Profile repo
  final dogProfileRepo = DogProfileRepoImpl();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(452, 778),
      child: MultiBlocProvider(
        providers: [
          // Auth cubit
          BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit(authRepo: authRepo)..checkUserAuthentication(),
          ),

          // Profile cubit
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              profileRepo: profileRepo,
            ),
          ),

          // Dog profile cubit
          BlocProvider<DogProfileCubit>(
            create: (context) => DogProfileCubit(
              dogProfileRepo: dogProfileRepo,
            ),
          ),

          // Cart provider
          ChangeNotifierProvider(create: (_) => CartProvider()),
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
              final cartProvider =
                  Provider.of<CartProvider>(context, listen: false);

              if (authState is UnAuthenticated) {
                cartProvider.reset(); // Reset cart on logout
                return const StartPage();
              }
              if (authState is Authenticated) {
                cartProvider
                    .setUserId(authState.user.uid); // Set userId on login
                return const NavBar();
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
