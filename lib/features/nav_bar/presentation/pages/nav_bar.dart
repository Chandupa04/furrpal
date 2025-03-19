import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/features/community/presentation/pages/community_page.dart';
import 'package:furrpal/features/home/presentation/pages/home_page.dart';
import 'package:furrpal/features/notifications/presentation/pages/notification_page.dart';
import 'package:furrpal/features/shop/presentation/pages/shop_page.dart';
import 'package:furrpal/features/user_profile/presentation/pages/user_profile.dart';

import '../../../../custom/container_custom.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List pages = [
    const HomePage(),
    const NotificationsPage(),
    const CommunityPage(),
    ShopPage(),
    const UserProfile(),
  ];
  int _currentIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
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

