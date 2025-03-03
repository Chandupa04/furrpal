import 'dart:io';
import 'package:flutter/material.dart';
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
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitPost() {
    if (_postController.text.isNotEmpty || _selectedImage != null) {
      // Here you can handle post submission (e.g., send data to backend)
      Navigator.pop(context); // Close the page after submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please add some text or an image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 10),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 150)
                : TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text("Add Image"),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text("Post"),
            ),
          ],
        ),
      ),
    );
  }
}
