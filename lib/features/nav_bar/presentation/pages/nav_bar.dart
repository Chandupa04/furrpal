import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/features/community/presentation/pages/community_page.dart';
import 'package:furrpal/features/home/presentation/pages/home_page.dart';
import 'package:furrpal/features/home/presentation/pages/notification_page.dart';
import 'package:furrpal/features/home/presentation/pages/pet_shop_page.dart';
import 'package:furrpal/features/user_profile/presentation/pages/user_profile.dart';



import '../../../../custom/container_custom.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List pages = [
    HomePage(),
    NotificationPage(),
    CommunityPage(),
    PetShopPage(),
    UserProfile(),
  ];
  int _curruntIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _curruntIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_curruntIndex],
      bottomNavigationBar: ContainerCustom(
        alignment: Alignment.topCenter,
        height: 60.h,
        bgColor: Color(0xffF88158),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
        shadow: [
          BoxShadow(
            offset: Offset(0, -4.h),
            blurRadius: 40.r,
            color: Color(0xffF88158).withOpacity(0.3),
          ),
        ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              'assets/icons/pet-house.png',
              'assets/icons/pet-house.png',
              0,
            ),
            _buildNavItem(
              'assets/icons/notification.png',
              'assets/icons/notification.png',
              1,
            ),
            _buildNavItem(
              'assets/icons/community.png',
              'assets/icons/community.png',
              2,
            ),
            _buildNavItem(
              'assets/icons/pet-shop.png',
              'assets/icons/pet-shop.png',
              3,
            ),
            _buildNavItem(
              'assets/icons/user_profile.png',
              'assets/icons/user_profile.png',
              4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String icon, String selectedIcon, int index) {
    final isSelected = _curruntIndex == index;
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
            bgColor: isSelected == true ? Colors.black : Colors.transparent,
          ),
          ContainerCustom(
            height: 32.h,
            width: 32.w,
            child: isSelected == true
                ? Image.asset(
                    selectedIcon,
                    color: Colors.black,
                  )
                : Image.asset(
                    icon,
                    color: Colors.white,
                  ),
          )
        ],
      ),
    );
  }
}
