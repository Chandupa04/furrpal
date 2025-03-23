import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:furrpal/features/community/presentation/pages/community_service.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _postController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitPost() async {
  if (_postController.text.isNotEmpty || _selectedImage != null) {
    if (_selectedImage != null) {
      var firebase = CommunityService();

      try {
        await firebase.createCommunityPost(
          caption: _postController.text,
          imageFile: _selectedImage,
        );

        // Return success result to CommunityPage
        if (mounted) {
          Navigator.pop(context, true); // Passing 'true' as a success flag
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error creating post: $e")),
        );
      }
    } else {
      log('No image selected');
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please add some text or an image")),
    );
  }
}


  Future<bool> _onBackPressed() async {
    if (_postController.text.isNotEmpty || _selectedImage != null) {
      bool? discard = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Discard Post?"),
            content: const Text(
                "You have unsaved changes. Do you want to discard them?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Stay on page
                child: const Text("Continue Editing"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // Discard post
                child: const Text("Discard"),
              ),
            ],
          );
        },
      );
      return discard ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Post"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _onBackPressed()) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _postController,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 150)
                  : TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text("Add Image"),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPost,
                child: const Text("Post"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
