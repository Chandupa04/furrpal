import 'package:flutter/material.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/community/presentation/widgets/community_post_card.dart';
import 'package:furrpal/features/user_profile/presentation/pages/user_profile.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primaryColor,
      appBar: AppBar(
        // backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: ImageIcon(
              AssetImage(
                'assets/icons/notification.png',
              ),
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: TextCustomWidget(text: 'Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(),
                ),
              );
            },
          ),
          CommunityPostCard()
        ],
      ),
    );
  }
}
