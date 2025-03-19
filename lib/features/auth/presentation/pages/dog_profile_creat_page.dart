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
  final TextEditingController _healthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? selectedGender;
  String? selectedBreed;
  int? selectedYears;
  int? selectedMonths;
  List<String> filteredBreeds = [];
  bool showBreedDropdown = false;

  // Define the range for dog age - most dogs live between 10-15 years
  final List<int> years = List.generate(16, (index) => index); // 0-15 years
  final List<int> months = List.generate(12, (index) => index); // 0-11 months

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
    'Saint Bernard',
    'Dalmatian',
    'Spitz',
    'German Spitz',
    'Sri Lankan Hound',
    'Sri Lankan Mastiff',
    'Japanese Spitz',
    'Lhasa Apso',
    'Pekingese',
    'Terrier',
    'Indian Pariah Dog (Desi Dog)',
    'Mixed Breed (Mongrel)',
    'Basset Hound',
    'French Bulldog',
    'American Bully',
    'Jack Russell Terrier',
    'Great Pyrenees',
    'Samoyed',
    'Belgian Malinois',
    'Weimaraner',
    'American Staffordshire Terrier',
    'Whippet',
    'Afghan Hound',
    'Tibetan Mastiff',
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
    _healthController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String getFormattedAge() {
    if (selectedYears == null && selectedMonths == null) {
      return '';
    }

    final years = selectedYears ?? 0;
    final months = selectedMonths ?? 0;

    if (years > 0 && months > 0) {
      return '$years years, $months months';
    } else if (years > 0) {
      return '$years years';
    } else {
      return '$months months';
    }
  }

  Widget _buildAgeDropdowns() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Years dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustomWidget(
                      text: 'Years',
                      fontSize: 14.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: DropdownButtonFormField<int>(
                        value: selectedYears,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                        hint: Text('Years'),
                        items: years.map((int year) {
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text('$year'),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            selectedYears = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // Months dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustomWidget(
                      text: 'Months',
                      fontSize: 14.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: DropdownButtonFormField<int>(
                        value: selectedMonths,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                        hint: Text('Months'),
                        items: months.map((int month) {
                          return DropdownMenuItem<int>(
                            value: month,
                            child: Text('$month'),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            selectedMonths = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
                  _buildAgeDropdowns(),
                  TextCustomWidget(
                    text: 'Health Conditions',
                    fontSize: 17.sp,
                    marginLeft: 9.w,
                    marginBottom: 4.h,
                    marginTop: 15.h,
                  ),
                  TextFieldCustom(
                    keyboardType: TextInputType.emailAddress,
                    controller: _healthController,
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

    if (_nameController.text.isEmpty ||
        _breedController.text.isEmpty ||
        selectedGender == null ||
        (selectedYears == null && selectedMonths == null) ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final String formattedAge = getFormattedAge();

    try {
      await _firebaseService.createDogProfile(
        name: _nameController.text,
        breed: _breedController.text,
        gender: selectedGender!,
        age: formattedAge,
        healthConditions: _healthController.text,
        location: _locationController.text,
        imageFile: _imageFile,
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
