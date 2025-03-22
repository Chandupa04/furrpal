import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png', // Change this to your actual logo path
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 25),

              // Form Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange.shade300, Colors.deepOrange.shade100],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align labels left
                  children: [
                    _buildLabeledTextField("Dog’s Name"),
                    const SizedBox(height: 20),

                    _buildLabeledTextField("Breed"),
                    const SizedBox(height: 20),

                    // Gender & Age Fields (Side by Side)
                    Row(
                      children: [
                        Expanded(child: _buildLabeledTextField("Gender")),
                        const SizedBox(width: 15),
                        Expanded(child: _buildLabeledTextField("Age")),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildLabeledTextField("Health Conditions"),
                    const SizedBox(height: 20),

                    _buildLabeledTextField("Location of the pet",
                        hintText: "Eg: Nearest town of the user"),
                    const SizedBox(height: 50), // Space before the button

                    // Submit Button (Inside the Form)
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                        ),
                        onPressed: () {
                          // Handle form submission
                        },
                        child: const Text(
                          "Create user profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, {String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Label color
          ),
        ),
        const SizedBox(height: 5), // Small spacing between label and field
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}