import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furrpal/features/community/presentation/pages/add_post_page.dart';
import 'package:furrpal/features/community/presentation/widgets/community_post_card.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primaryColor,
      appBar: AppBar(
        // backgroundColor: primaryColor,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(width: 0), // Remove leading space
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "FurrPal",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPostPage(),
                  ),
                );
              },
              icon: const Icon(CupertinoIcons.add)),
        ],
      ),
      body: const Column(
        children: [CommunityPostCard()],
      ),
    );
  }
}
