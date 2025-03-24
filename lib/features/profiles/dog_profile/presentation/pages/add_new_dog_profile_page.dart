import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/cubit/dog_profile_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../custom/button_custom.dart';
import '../../../../../custom/container_custom.dart';
import '../../../../../custom/text_custom.dart';
import '../../../../../custom/textfield_custom.dart';
import '../cubit/dog_profile_cubit.dart';

class AddNewDogProfilePage extends StatefulWidget {
  const AddNewDogProfilePage({super.key});

  @override
  State<AddNewDogProfilePage> createState() => _AddNewDogProfilePageState();
}

class _AddNewDogProfilePageState extends State<AddNewDogProfilePage> {
  File? selectedFile;
  String? selectedGender;
  String? selectedBreed;
  File? healthReportFile;
  String? healthReportName;
  int? selectedYears;
  int? selectedMonths;

  final List<int> years = List.generate(16, (index) => index);
  final List<int> months = List.generate(12, (index) => index);

  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController weightKgcontroller = TextEditingController();
  final TextEditingController locationTextController = TextEditingController();
  final TextEditingController bloodlineTextController = TextEditingController();

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> pickHealthReport() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          healthReportFile = File(result.files.single.path!);
          healthReportName = result.files.single.name;
        });
      }
    } catch (e) {
      print("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  String getFormattedAge() {
    if (selectedYears == null && selectedMonths == null) {
      return '';
    }

    final years = selectedYears ?? 0;
    final months = selectedMonths ?? 0;

    if (years > 0 && months > 0) {
      return '$years.$months yrs';
    } else if (years > 0) {
      return '$years yrs';
    } else {
      return '$months months';
    }
  }

  Widget buildAgeDropdowns() {
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<int>(
                        value: selectedYears,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: const Color(0xFFFBA182)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: Text(
                          'Years',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16.sp,
                          ),
                        ),
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
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade700,
                        ),
                        dropdownColor: Colors.white,
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<int>(
                        value: selectedMonths,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: const Color(0xFFFBA182)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: Text(
                          'Months',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16.sp,
                          ),
                        ),
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
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade700,
                        ),
                        dropdownColor: Colors.white,
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

  void addNewProfile() async {
    final dogProfileCubit = context.read<DogProfileCubit>();

    final String name = nameTextController.text;
    final String weightKg = weightKgcontroller.text;
    final String location = locationTextController.text;
    final String bloodline = bloodlineTextController.text;
    final String formattedAge = getFormattedAge();

    if (name.isEmpty ||
        formattedAge.isEmpty ||
        location.isEmpty ||
        weightKg.isEmpty ||
        selectedFile == null ||
        selectedGender == null ||
        selectedBreed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r))),
          content: TextCustomWidget(
            text: 'Please Fill All required fields',
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return;
    } else {
      dogProfileCubit.addNewDogProfile(
        profileImage: selectedFile!,
        name: name,
        age: formattedAge,
        weightKg: weightKg,
        breed: selectedBreed!,
        gender: selectedGender!,
        location: location,
        bloodline: bloodline,
        healthReportUrl: healthReportName,
      );
    }
  }

  @override
  void dispose() {
    nameTextController.dispose();
    locationTextController.dispose();
    weightKgcontroller.dispose();
    bloodlineTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DogProfileCubit, DogProfileState>(
        builder: (context, state) {
          if (state is DogProfileLoading) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: CircularProgressIndicator()),
                  TextCustomWidget(
                    text: 'Uploading...',
                    fontSize: 18.sp,
                    textColor: blackColor,
                    containerAlignment: Alignment.center,
                  ),
                ],
              ),
            );
          } else {
            return buildAddDogPage();
          }
        }, listener: (context, state) {
      if (state is DogProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildAddDogPage() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Add New Dog Profile',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image Section
              Padding(
                padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
                child: Center(
                  child: Column(
                    children: [
                      // Profile Image with Picker
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: selectedFile != null
                              ? ClipOval(
                            child: Image.file(
                              selectedFile!,
                              width: 120.w,
                              height: 120.h,
                              fit: BoxFit.cover,
                            ),
                          )
                              : CachedNetworkImage(
                            imageUrl: '',
                            placeholder: (context, url) => ContainerCustom(
                              width: 120.w,
                              height: 120.h,
                              shape: BoxShape.circle,
                              bgColor: Colors.white.withOpacity(0.3),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => ContainerCustom(
                              width: 120.w,
                              height: 120.h,
                              shape: BoxShape.circle,
                              bgColor: Colors.grey.shade200,
                              child: Icon(
                                LucideIcons.dog,
                                size: 72.h,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            imageBuilder: (context, imageProvider) =>
                                ContainerCustom(
                                  width: 120.w,
                                  height: 120.h,
                                  shape: BoxShape.circle,
                                  decorationImage: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Tap to change text
                      Text(
                        'Tap to add dog photo',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Form Fields in Cards
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.dog,
                          color: const Color(0xFFFBA182),
                          size: 22.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Basic Information',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24.h, thickness: 1),
                    SizedBox(height: 8.h),

                    // Name
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFieldCustom(
                      controller: nameTextController,
                      hintText: 'Enter dog name',
                      borderColor: Colors.grey.shade300,
                      marginBottom: 15.h,
                    ),

                    // Age
                    Text(
                      'Age',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    buildAgeDropdowns(),

                    // Weight
                    Text(
                      'Weight (Kg)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFieldCustom(
                      controller: weightKgcontroller,
                      hintText: 'Enter weight in kg',
                      keyboardType: TextInputType.number,
                      borderColor: Colors.grey.shade300,
                      marginBottom: 15.h,
                    ),

                    // Gender
                    Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        hint: Text(
                          'Select Gender',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16.sp,
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 15.h),
                        dropdownColor: whiteColor,
                        value: selectedGender,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: const Color(0xFFFBA182)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: genders.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // Breed
                    Text(
                      'Breed',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        hint: Text(
                          'Select breed',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16.sp,
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 15.h),
                        value: selectedBreed,
                        dropdownColor: whiteColor,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: const Color(0xFFFBA182)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: breeds.map((String breed) {
                          return DropdownMenuItem<String>(
                            value: breed,
                            child: Text(breed),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBreed = newValue!;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Additional Information Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFFFBA182),
                          size: 22.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24.h, thickness: 1),
                    SizedBox(height: 8.h),

                    // Blood Line
                    Text(
                      'Blood Line',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFieldCustom(
                      controller: bloodlineTextController,
                      hintText: 'Blood Line (Optional)',
                      borderColor: Colors.grey.shade300,
                      marginBottom: 15.h,
                    ),

                    // Health Report
                    Text(
                      'Health Report (PDF) (Optional)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: pickHealthReport,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                        margin: EdgeInsets.only(bottom: 15.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                healthReportName ?? 'Upload health report (PDF)',
                                style: TextStyle(
                                  color: healthReportName != null
                                      ? Colors.black
                                      : Colors.grey.shade600,
                                  fontSize: 16.sp,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.upload_file,
                              color: healthReportName != null
                                  ? const Color(0xFFFBA182)
                                  : Colors.grey.shade600,
                              size: 22.sp,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Location
                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFieldCustom(
                      controller: locationTextController,
                      hintText: 'Enter location',
                      borderColor: Colors.grey.shade300,
                      marginBottom: 15.h,
                    ),
                  ],
                ),
              ),

              // Add Profile Button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: ButtonCustom(
                  text: 'Add Profile',
                  callback: addNewProfile,
                  btnColor: const Color(0xFFFBA182),
                  textColor: Colors.white,
                  btnHeight: 50.h,
                  borderRadius: BorderRadius.circular(12.r),
                  elevation: 5,
                  dontApplyMargin: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}