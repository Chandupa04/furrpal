import 'package:flutter/material.dart';
import 'package:furrpal/constant/constant.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final Map<int, List<String>> _replies = {};
  final List<String> _comments = [];

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a comment")),
      );
    }
  }

  void _addReply(int commentIndex) {
    TextEditingController replyController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Reply to Comment"),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(hintText: "Enter your reply..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (replyController.text.isNotEmpty) {
                  setState(() {
                    _replies.putIfAbsent(commentIndex, () => []).add(replyController.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Reply"),
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
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(_comments[index]),
                      leading: Icon(Icons.person),
                      trailing: TextButton(
                        onPressed: () => _addReply(index),
                        child: Text("Reply"),
                      ),
                    ),
                    if (_replies.containsKey(index)) ..._replies[index]!.map((reply) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: ListTile(
                          title: Text(reply),
                          leading: Icon(Icons.reply, color: Colors.grey),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(40.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
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
