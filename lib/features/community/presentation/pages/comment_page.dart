import 'package:flutter/material.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/features/community/presentation/pages/community_service.dart';

class CommentPage extends StatefulWidget {
  final List<Map<String, dynamic>> comments; // Accept comments as a parameter
  final String postId;
  final String postOwnerId;
  final Function
      onCommentAdd; // Callback to update comments when a comment is added

  const CommentPage({
    super.key,
    required this.comments,
    required this.postId,
    required this.postOwnerId,
    required this.onCommentAdd,
  });

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final Map<int, List<String>> _replies = {};
  final Map<int, bool> _likedComments = {};

  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      await CommunityService().commentPost(
        postId: widget.postId,
        postOwnerId: widget.postOwnerId,
        content: _commentController.text,
      );
      setState(() {
        _commentController.clear();
      });
      widget.onCommentAdd();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a comment")),
      );
    }
  }

  void _toggleLike(int index) {
    setState(() {
      _likedComments[index] = !(_likedComments[index] ?? false);
    });
  }

  void _addReply(int commentIndex) {
    TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reply to Comment"),
          content: TextField(
            controller: replyController,
            decoration: const InputDecoration(hintText: "Enter your reply..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (replyController.text.isNotEmpty) {
                  setState(() {
                    _replies
                        .putIfAbsent(commentIndex, () => [])
                        .add(replyController.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Reply"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Comments',
          style: appBarStyle,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Displaying the user's name in bold before the comment
                          Text(
                            widget.comments[index]['name'] ?? 'Unknown User',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Displaying the comment content
                          Text(widget.comments[index]['content'] ?? ''),
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 20, // Size of the avatar
                        backgroundImage: widget.comments[index]
                                        ['profilePicture'] !=
                                    null &&
                                widget.comments[index]['profilePicture']
                                    .isNotEmpty
                            ? NetworkImage(
                                widget.comments[index]['profilePicture'])
                            : const AssetImage('assets/icons/user_profile.png')
                                as ImageProvider, // Default avatar if no profile picture
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black,
                              size: 20,
                            ),
                            onPressed: () async {
                              final confirmDelete = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Comment'),
                                  content: const Text(
                                      'Are you sure you want to delete this comment?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                          context, false), // Cancel the dialog
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                          context, true), // Confirm deletion
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmDelete == true) {
                                await CommunityService().deleteComment(
                                  postOwnerId: widget.postOwnerId,
                                  postId: widget.postId,
                                  index: index,
                                  comments: widget.comments,
                                );
                                widget.onCommentAdd();
                                Navigator.pop(context);
                              }
                            },
                          ),
                          // You can uncomment the below part if you want to add like functionality
                          // IconButton(
                          //   icon: Icon(
                          //     _likedComments[index] == true
                          //         ? Icons.favorite
                          //         : Icons.favorite_border,
                          //     color: _likedComments[index] == true
                          //         ? Colors.red
                          //         : Colors.grey,
                          //   ),
                          //   onPressed: () => _toggleLike(index),
                          // ),
                          // TextButton(
                          //   onPressed: () => _addReply(index),
                          //   child: const Text("Reply"),
                          // ),
                        ],
                      ),
                    ),
                    if (_replies.containsKey(index))
                      ..._replies[index]!.map((reply) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: ListTile(
                            title: Text(reply),
                            leading:
                                const Icon(Icons.reply, color: Colors.grey),
                          ),
                        );
                      }),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
