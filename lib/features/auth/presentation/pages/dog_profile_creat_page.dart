import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/config/firebase_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../custom/container_custom.dart';
import '../../../../custom/text_custom.dart';
import '../../../../custom/textfield_custom.dart';

class DogProfileCreatPage extends StatefulWidget {
  const DogProfileCreatPage({super.key});

  @override
  State<DogProfileCreatPage> createState() => _DogProfileCreatPageState();
}

class _DogProfileCreatPageState extends State<DogProfileCreatPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;

  Future<void> _testFirestore() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Test if we can access Firestore
      print("Testing Firestore connection...");
      await firestore.collection('test').doc('test').set({
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Test connection'
      });
      print("Firestore test write successful");

      // Try to read the document back
      final docSnapshot = await firestore.collection('test').doc('test').get();
      print("Firestore test read successful: ${docSnapshot.exists}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firestore connection test successful')),
      );
    } catch (e) {
      print("Firestore test failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firestore test failed: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _createDogProfile() async {
    if (_nameController.text.isEmpty ||
        _breedController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _firebaseService.createDogProfile(
        name: _nameController.text,
        breed: _breedController.text,
        gender: _genderController.text,
        age: _ageController.text,
        healthConditions: _healthController.text,
        location: _locationController.text,
        imageFile: _imageFile,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dog profile created successfully!')),
      );

      // Navigate back or to home page
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _healthController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
      ),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(75.r),
                      child: Image.file(
                        _imageFile!,
                        width: 150.w,
                        height: 150.h,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          logoImage,
                          width: 150.w,
                          height: 150.h,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 24.r,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            ContainerCustom(
              marginLeft: 13.w,
              marginRight: 13.w,
              marginBottom: 10.h,
              paddingLeft: 23.w,
              paddingRight: 23.w,
              paddingTop: 24.h,
              paddingBottom: 24.h,
              borderRadius: BorderRadius.circular(16.r),
              gradient: primaryGradient,
              child: Column(
                children: [
                  TextCustomWidget(
                    text: "Dog's Name",
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    marginBottom: 15.h,
                    controller: _nameController,
                  ),
                  TextCustomWidget(
                    text: 'Breed',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    marginBottom: 15.h,
                    controller: _breedController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustomWidget(
                            text: 'Gender',
                            fontSize: 17.sp,
                            marginLeft: 9.w,
                            marginBottom: 4.h,
                          ),
                          TextFieldCustom(
                            width: 151.w,
                            controller: _genderController,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustomWidget(
                            text: 'Age',
                            fontSize: 17.sp,
                            marginLeft: 9.w,
                            marginBottom: 4.h,
                          ),
                          TextFieldCustom(
                            width: 151.w,
                            controller: _ageController,
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextCustomWidget(
                    text: 'Health Conditions',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                    marginTop: 15.h,
                  ),
                  TextFieldCustom(
                    keyboardType: TextInputType.emailAddress,
                    marginBottom: 15.h,
                    controller: _healthController,
                  ),
                  TextCustomWidget(
                    text: 'Location of the pet',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    marginBottom: 27.h,
                    controller: _locationController,
                  ),
                  ButtonCustom(
                    text: 'Create Profile',
                    dontApplyMargin: true,
                    callback: _createDogProfile,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
