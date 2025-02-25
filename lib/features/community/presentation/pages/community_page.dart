import 'package:flutter/material.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/features/community/presentation/widgets/community_post_card.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
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
        children: [CommunityPostCard()],
      ),
    );
  }
}
