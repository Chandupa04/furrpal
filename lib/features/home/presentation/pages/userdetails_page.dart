import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Clipboard for copy function
import 'package:flutter/cupertino.dart'; // Import Cupertino for iOS styling
import 'package:furrpal/features/home/presentation/pages/dog_profile_page.dart';
import 'package:furrpal/config/firebase_service.dart';

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
  bool isLoading = false;
  List<Map<String, dynamic>>? userDogs;

  @override
  void initState() {
    super.initState();
    _loadUserDogs();
  }

  Future<void> _loadUserDogs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dogs = await _firebaseService.getUserDogs(widget.email);

      if (mounted) {
        setState(() {
          userDogs = dogs;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user dogs: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
                    CircleAvatar(
                      radius: 90,
                      backgroundImage: widget.imagePath.isNotEmpty &&
                          (widget.imagePath.startsWith('http') ||
                              widget.imagePath.startsWith('assets'))
                          ? (widget.imagePath.startsWith('http')
                          ? NetworkImage(widget.imagePath)
                          : AssetImage(widget.imagePath) as ImageProvider)
                          : null,
                      backgroundColor: CupertinoColors.systemGrey5,
                      child: (!widget.imagePath.isNotEmpty ||
                          (!widget.imagePath.startsWith('http') &&
                              !widget.imagePath.startsWith('assets')))
                          ? const Icon(
                        Icons.person,
                        size: 80,
                        color: CupertinoColors.systemGrey,
                      )
                          : null,
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
                    boxShadow: const [
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

              const SizedBox(height: 40),

              // Add button to view dog profile
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (userDogs != null && userDogs!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DogProfilePage(
                            dogId: userDogs!.first['id'],
                            userId: userDogs!.first['ownerId'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF333333),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      minimumSize: const Size(double.infinity, 54),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, size: 20),
                        SizedBox(width: 10),
                        Text(
                          "View Dog Profile",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "No dog profiles found for this user",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
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

