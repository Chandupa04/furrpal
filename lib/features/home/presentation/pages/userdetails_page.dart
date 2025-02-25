import 'package:flutter/material.dart';

void main() {
  runApp(UserDetailsApp());
}

class UserDetailsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserDetailsPage(),
    );
  }
}

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String name = "James Taylor";
  String email = "james@email.com";
  String address = "78/A Park lane.";
  String contact = "0714586235";
  String since = "since 2024";
  String imagePath = "assets/images/man.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient Background
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 70, bottom: 20),
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 100, // Increased radius to make the image larger
                        backgroundImage: AssetImage(imagePath),
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Display 'since' without edit icon
                  Text(
                    since,
                    style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // User Details Card (Larger and more spacious)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(30), // Increased padding for a taller card
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
                    _buildDetailRow("Name", name),
                    SizedBox(height: 50), // Increased space between fields
                    _buildDetailRow("Email", email),
                    SizedBox(height: 50), // Increased space between fields
                    _buildDetailRow("Address", address),
                    SizedBox(height: 50), // Increased space between fields
                    _buildDetailRow("Contact number", contact),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 22, color: Colors.black87),
        ),
      ],
    );
  }
}
