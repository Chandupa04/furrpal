import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserDetailsPage extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const UserDetailsPage({Key? key, required this.userDetails}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Gradient Background
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 100, bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepOrange.shade400, Colors.deepOrange.shade200],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('assets/images/man.png'),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.userDetails['since'] ?? 'Member since 2024',
                        style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // User Details Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Name", widget.userDetails['name'] ?? 'Unknown'),
                        SizedBox(height: 50),
                        _buildDetailRow("Email", widget.userDetails['email'] ?? 'Unknown', isCopyable: true),
                        SizedBox(height: 50),
                        _buildDetailRow("Address", widget.userDetails['address'] ?? 'Unknown'),
                        SizedBox(height: 50),
                        _buildDetailRow("Contact number", widget.userDetails['contact'] ?? 'Unknown', isCopyable: true),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: SafeArea(
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isCopyable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 5),
        isCopyable
            ? GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$label copied!")),
            );
          },
          child: Text(
            value,
            style: TextStyle(
              fontSize: 22,
              color: Colors.blue,
            ),
          ),
        )
            : Text(
          value,
          style: TextStyle(fontSize: 22, color: Colors.black87),
        ),
      ],
    );
  }
}
