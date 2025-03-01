import 'package:flutter/material.dart';
import 'package:furrpal/constant/constant.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({super.key});

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
    );
  }
}
