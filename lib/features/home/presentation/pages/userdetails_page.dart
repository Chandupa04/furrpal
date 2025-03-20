import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Clipboard for copy function

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key, required name, required email, required address, required contact, required since, required imagePath});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String name = "Bill Taylor";
  String email = "james@email.com";
  String address = "78/A Park lane.";
  String contact = "0714586235";
  String since = "since 2024";
  String imagePath = "assets/images/man.jpg";

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
                  padding: const EdgeInsets.only(top: 70, bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepOrange.shade400,
                        Colors.deepOrange.shade200
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage(imagePath),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        since,
                        style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // User Details Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
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
                        _buildDetailRow("Name", name),
                        const SizedBox(height: 50),
                        _buildDetailRow("Email", email, isCopyable: true),
                        const SizedBox(height: 50),
                        _buildDetailRow("Address", address),
                        const SizedBox(height: 50),
                        _buildDetailRow("Contact number", contact, isCopyable: true),
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
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop(); // This will navigate back to the previous page (HomePage)
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
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 5),
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
            style: const TextStyle(
              fontSize: 22,
              color: Colors.blue,
            ),
          ),
        )
            : Text(
          value,
          style: const TextStyle(fontSize: 22, color: Colors.black87),
        ),
      ],
    );
  }
}

