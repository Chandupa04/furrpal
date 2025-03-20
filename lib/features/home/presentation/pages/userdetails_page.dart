import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Clipboard for copy function
import 'package:flutter/cupertino.dart'; // Import Cupertino for iOS styling

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
                      backgroundImage: widget.imagePath.startsWith('http') ||
                              widget.imagePath.startsWith('assets')
                          ? (widget.imagePath.startsWith('http')
                              ? NetworkImage(widget.imagePath)
                              : AssetImage(widget.imagePath) as ImageProvider)
                          : null,
                      backgroundColor: CupertinoColors.systemGrey5,
                      child: !widget.imagePath.startsWith('http') &&
                              !widget.imagePath.startsWith('assets')
                          ? Icon(
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
