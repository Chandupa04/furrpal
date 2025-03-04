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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPostPage(),
                          ),
                        );},
            icon: Icon(CupertinoIcons.add)
          ),
        ],
      ),
      body: Column(
        children: [CommunityPostCard()],
      ),
    );
  }
}
