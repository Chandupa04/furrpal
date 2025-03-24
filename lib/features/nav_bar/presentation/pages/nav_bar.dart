import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/community/presentation/pages/community_page.dart';
import 'package:furrpal/features/home/presentation/pages/home_page.dart';
import 'package:furrpal/features/notifications/presentation/pages/notification_page.dart';
import 'package:furrpal/features/shop/presentation/pages/shop_page.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/pages/user_profile.dart';
import '../../../../custom/container_custom.dart';
import '../../../auth/presentation/pages/start_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool isVerifiedEmail =
      FirebaseAuth.instance.currentUser?.emailVerified ?? false;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser!.reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //get the current user
    final user = context.read<AuthCubit>().currentUser;
    String? uid = user!.uid;

    if (isVerifiedEmail) {
      return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const HomePage(),
            const NotificationsPage(),
            const CommunityPage(),
            const ShopPage(),
            UserProfile(uid: uid),
          ],
        ),
        bottomNavigationBar: ContainerCustom(
          alignment: Alignment.topCenter,
          height: 60.h,
          bgColor: const Color.fromARGB(255, 242, 241, 240),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
          shadow: [
            BoxShadow(
              offset: Offset(0, -4.h),
              blurRadius: 40.r,
              color: const Color(0xffF88158).withOpacity(0.2),
            ),
          ],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                CupertinoIcons.house,
                CupertinoIcons.house_fill,
                0,
              ),
              _buildNavItem(
                CupertinoIcons.bell,
                CupertinoIcons.bell_fill,
                1,
              ),
              _buildNavItem(
                CupertinoIcons.group,
                CupertinoIcons.group_solid,
                2,
              ),
              _buildNavItem(
                CupertinoIcons.cart,
                CupertinoIcons.cart_fill,
                3,
              ),
              _buildNavItem(
                CupertinoIcons.person_alt_circle,
                CupertinoIcons.person_alt_circle_fill,
                4,
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: postColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextCustomWidget(
                text: 'Please verify your email to access to furrpal.',
                fontSize: 24.sp,
                textAlign: TextAlign.center,
                textColor: blackColor,
                marginBottom: 15.h,
              ),
            ),
            ButtonCustom(
              callback: () {
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
              ischildPositionRight: true,
              text: 'Logout',
              child: const Icon(
                Icons.logout,
                color: whiteColor,
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _buildNavItem(IconData icon, IconData selectedIcon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTap(index),
      child: Column(
        children: [
          ContainerCustom(
            width: 64.w,
            height: 4.h,
            marginBottom: 14.h,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(6.r),
              bottomRight: Radius.circular(6.r),
            ),
            bgColor: isSelected ? const Color(0xffF88158) : Colors.transparent,
          ),
          Icon(
            isSelected ? selectedIcon : icon,
            size: 32.w,
            color: isSelected
                ? const Color(0xffF88158) // Change color for active state
                : Colors.grey, // Change color for inactive state
          ),
        ],
      ),
    );
  }
}
