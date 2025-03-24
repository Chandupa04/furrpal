import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furrpal/features/community/presentation/pages/add_post_page.dart';
import 'package:furrpal/features/community/presentation/pages/community_service.dart';
import 'package:furrpal/features/community/presentation/widgets/community_post_card.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late Future<List<Map<String, dynamic>>> _communityPosts;

  @override
  void initState() {
    super.initState();
    _loadCommunityPosts();
  }

  void _loadCommunityPosts() {
    setState(() {
      _communityPosts = CommunityService().getAllCommunityPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPostPage(),
                ),
              );

              if (result == true) {
                _loadCommunityPosts(); // Refresh posts
              }
            },
            icon: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _communityPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return CommunityPostCard(
                name: post['name'] ?? 'Unknown',
                date: post['date'] ?? 'N/A',
                profilePictureUrl: post['profilePictureUrl'] ?? '',
                imageUrl: post['imageUrl'] ?? '',
                caption: post['caption'] ?? '',
                postId: post['post_id'] ?? '',
                postOwnerId: post['postOwnerId'] ?? '',
                likes: List<Map<String, dynamic>>.from(post['likes'] ?? []),
                comments: List<Map<String, dynamic>>.from(post['comments'] ?? []),
                onPostDeleted: _loadCommunityPosts);
            },
          );
        },
      ),
    );
  }
}
