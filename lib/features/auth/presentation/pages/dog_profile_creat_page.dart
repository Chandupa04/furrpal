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
import 'package:file_picker/file_picker.dart';

class DogProfileCreatPage extends StatefulWidget {
  const DogProfileCreatPage({super.key});

  @override
  State<DogProfileCreatPage> createState() => _DogProfileCreatPageState();
}

class _DogProfileCreatPageState extends State<DogProfileCreatPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _weightKgController = TextEditingController();
  final TextEditingController _weightGController = TextEditingController();
  final TextEditingController _bloodlineController = TextEditingController();

  String? selectedGender;
  String? selectedBreed;
  List<String> filteredBreeds = [];
  bool showBreedDropdown = false;

  File? _healthReportFile;
  String? _healthReportName;

  final List<String> breeds = [
    'Labrador Retriever',
    'Golden Retriever',
    'Bulldog',
    'Beagle',
    'German Shepherd',
    'Poodle',
    'Dachshund',
    'Rottweiler',
    'Shih Tzu',
    'Doberman',
    'Chihuahua',
    'Great Dane',
    'Pug',
    'Cocker Spaniel',
    'Border Collie',
    'Siberian Husky',
    'Boxer',
    'Maltese',
    'Pomeranian',
    'Saint Bernard'
  ];

  final List<String> genders = ['Male', 'Female'];

  File? _imageFile;
  // bool _isLoading = false;

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

  Future<void> _pickHealthReport() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _healthReportFile = File(result.files.single.path!);
          _healthReportName = result.files.single.name;
        });
      }
    } catch (e) {
      print("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    filteredBreeds = breeds;
  }

  void filterBreeds(String query) {
    setState(() {
      filteredBreeds = breeds
          .where((breed) => breed.toLowerCase().contains(query.toLowerCase()))
          .toList();
      showBreedDropdown = query.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _weightKgController.dispose();
    _weightGController.dispose();
    _bloodlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        leading: const SizedBox(width: 0),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "FurrPal",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.pets,
                color: Colors.black,
                size: 28,
              ),
            ],
          ),
        ),
        centerTitle: true,
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
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showBreedDropdown = true;
                          });
                        },
                        child: TextFieldCustom(
                          controller: _breedController,
                          onChanged: filterBreeds,
                        ),
                      ),
                      if (showBreedDropdown && filteredBreeds.isNotEmpty)
                        Container(
                          constraints: BoxConstraints(maxHeight: 200.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredBreeds.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(filteredBreeds[index]),
                                onTap: () {
                                  setState(() {
                                    _breedController.text =
                                    filteredBreeds[index];
                                    showBreedDropdown = false;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  TextCustomWidget(
                    text: 'Gender',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                      items: genders.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGender = newValue;
                        });
                      },
                    ),
                  ),
                  TextCustomWidget(
                    text: 'Age',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
                    controller: _ageController,
                  ),

                  // Weight fields (kg and g)
                  TextCustomWidget(
                    text: 'Weight (Required)',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                    marginTop: 15.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustomWidget(
                              text: 'kg',
                              fontSize: 14.sp,
                              marginLeft: 9.w,
                              marginBottom: 4.h,
                            ),
                            TextFieldCustom(
                              controller: _weightKgController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustomWidget(
                              text: 'g',
                              fontSize: 14.sp,
                              marginLeft: 9.w,
                              marginBottom: 4.h,
                            ),
                            TextFieldCustom(
                              controller: _weightGController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Bloodline field (optional)
                  TextCustomWidget(
                    text: 'Bloodline (Optional)',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                    marginTop: 15.h,
                  ),
                  TextFieldCustom(
                    controller: _bloodlineController,
                    marginBottom: 15.h,
                  ),

                  // Health Report (PDF) upload
                  TextCustomWidget(
                    text: 'Health Report (PDF) (Required)',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                    marginTop: 15.h,
                  ),
                  GestureDetector(
                    onTap: _pickHealthReport,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                      margin: EdgeInsets.only(bottom: 15.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _healthReportName ?? 'Upload health report (PDF)',
                              style: TextStyle(
                                color: _healthReportName != null ? Colors.black : Colors.grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Icon(Icons.upload_file, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  TextCustomWidget(
                    text: 'Location of the pet',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                  ),
                  TextFieldCustom(
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

  Future<void> _createDogProfile() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a profile picture')),
      );
      return;
    }

    // Check for required fields including new mandatory fields
    if (_nameController.text.isEmpty ||
        _breedController.text.isEmpty ||
        selectedGender == null ||
        _ageController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _weightKgController.text.isEmpty ||
        _weightGController.text.isEmpty ||
        _healthReportFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      await _firebaseService.createDogProfile(
        name: _nameController.text,
        breed: _breedController.text,
        gender: selectedGender!,
        age: _ageController.text,
        location: _locationController.text,
        imageFile: _imageFile,
        weightKg: _weightKgController.text,
        weightG: _weightGController.text,
        bloodline: _bloodlineController.text,
        healthReportFile: _healthReportFile,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dog profile created successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating profile: $e')),
      );
    }
  }
}