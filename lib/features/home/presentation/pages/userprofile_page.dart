import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const UserProfileApp());
}

class UserProfileApp extends StatelessWidget {
  const UserProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfileWidget(),
    );
  }
}

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({super.key});

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Go back when pressed
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image Picker Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors
                        .deepOrange.shade100, // Background color of the circle
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/images/placeholder.jpg')
                            as ImageProvider,
                    child: _image == null
                        ? const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                ),
              ),

              // Add space between image picker and form fields
              const SizedBox(height: 60),

              // Profile Fields Section with background gradient applied only to the container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepOrange.shade300,
                      Colors.deepOrange.shade100,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Keep fields background white
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your name' : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Keep fields background white
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your email' : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Keep fields background white
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your phone number'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Keep fields background white
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.home),
                        ),
                        maxLines: 3,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your address' : null,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Here you would typically send the data to your backend
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile Updated')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors
                            .deepOrange.shade100, // Button background color
                        foregroundColor:
                            Colors.deepOrange.shade300, // Text color
                      ),
                      child: const Text('Save Profile'),
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
}
