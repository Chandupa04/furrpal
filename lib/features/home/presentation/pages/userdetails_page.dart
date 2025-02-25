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

class UserDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Gradient Background
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 70, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300, Colors.deepOrange.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage("assets/images/man.jpg"), // Change this to your image path
                ),
                SizedBox(height: 15),
                Text(
                  "since 2024",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ],
            ),
          ),

          SizedBox(height: 30),

          // User Details Card (Bigger & More Spacious)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Name", "James Taylor"),
                  SizedBox(height: 50), // Increased spacing
                  _buildInfoRow("Email", "james@email.com"),
                  SizedBox(height: 50),
                  _buildInfoRow("Address", "78/A Park lane."),
                  SizedBox(height: 50),
                  _buildInfoRow("Contact number", "0714586235"),
                ],
              ),
            ),
          ),

          Spacer(),

          // Bottom Navigation Bar
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Colors.black54,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ""),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:       ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 20, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
