import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Clipboard for copy function
import 'package:flutter/cupertino.dart'; // Import Cupertino for iOS styling
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furrpal/config/firebase_service.dart';

void main() {
  runApp(const UserDetailsApp());
}

class UserDetailsApp extends StatelessWidget {
  const UserDetailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserDetailsPage(
        name: "James Taylor",
        email: "james@email.com",
        address: "78/A Park lane.",
        contact: "0714586235",
        since: "since 2024",
        imagePath: "assets/images/man.jpg",
      ),
    );
  }
}

class UserDetailsPage extends StatefulWidget {
  final String name;
  final String email;
  final String address;
  final String contact;
  final String since;
  final String imagePath;

  const UserDetailsPage({
    super.key,
    required this.name,
    required this.email,
    required this.address,
    required this.contact,
    required this.since,
    required this.imagePath,
  });

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imagePath;
  }

  Future<void> _pickAndUploadImage() async {
    try {
      setState(() => _isLoading = true);

      // Pick image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user logged in')),
        );
        return;
      }

      // Upload image
      final String? downloadUrl = await _firebaseService.uploadUserProfileImage(
        user.uid,
        File(image.path),
      );

      if (downloadUrl != null) {
        setState(() {
          _imageUrl = downloadUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemBackground,
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemBackground,
        elevation: 0,
        title: const Text(
          'FurrPal',
          style: TextStyle(
            color: CupertinoColors.label,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CupertinoColors.label),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 90,
                            backgroundImage: _imageUrl != null
                                ? NetworkImage(_imageUrl!)
                                : AssetImage(widget.imagePath) as ImageProvider,
                            backgroundColor: CupertinoColors.systemGrey5,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: CupertinoColors.activeBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: CupertinoColors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // User Details Card with iOS styling
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey5,
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Email", widget.email, isCopyable: true),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _buildDetailRow("Address", widget.address),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _buildDetailRow("Contact number", widget.contact,
                          isCopyable: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated _buildDetailRow with iOS styling
  Widget _buildDetailRow(String label, String value,
      {bool isCopyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isCopyable
                ? GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      _showIosStyleToast("$label copied!");
                    },
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 17,
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 17,
                      color: CupertinoColors.label,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                  ),
          ),
        ],
      ),
    );
  }

  // iOS-style toast message
  void _showIosStyleToast(String message) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ),
    );
  }
}
