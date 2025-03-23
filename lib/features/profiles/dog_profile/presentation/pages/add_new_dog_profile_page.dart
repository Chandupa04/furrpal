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
      appBar: AppBar(
        title: Text(
          'Add New Dog Profile',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ContainerCustom(
          marginLeft: 24.w,
          marginRight: 24.w,
          child: Column(
            children: [
              ContainerCustom(
                callback: pickImage,
                height: 200.h,
                width: 200.h,
                shape: BoxShape.circle,
                bgColor: Colors.grey.shade500,
                clipBehavior: Clip.hardEdge,
                child: (selectedFile != null)
                    ? Image.file(
                        selectedFile!,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: '',
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(
                          LucideIcons.dog,
                          size: 82.h,
                          color: Colors.black,
                        ),
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              TextCustomWidget(
                text: 'Name',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginTop: 10.h,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: nameTextController,
                hintText: 'Name',
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'Age',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              buildAgeDropdowns(),
              TextCustomWidget(
                text: 'weight (Kg)',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: weightKgcontroller,
                hintText: 'weightKg',
                keyboardType: TextInputType.number,
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'Gender',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              DropdownButtonFormField<String>(
                hint: TextCustomWidget(
                  text: 'Select Gender',
                  textColor: Colors.grey,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                padding: EdgeInsets.only(bottom: 15.h),
                dropdownColor: whiteColor,
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
                    selectedGender = newValue!;
                  });
                },
              ),
              TextCustomWidget(
                text: 'Breed',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              DropdownButtonFormField<String>(
                hint: TextCustomWidget(
                  text: 'Select breed',
                  textColor: Colors.grey,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                padding: EdgeInsets.only(bottom: 15.h),
                value: selectedBreed,
                dropdownColor: whiteColor,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
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
              ),
              TextCustomWidget(
                text: 'Blood Line',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: bloodlineTextController,
                hintText: 'Blood Line (Optional)',
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'Health Report (PDF) (Optional)',
                textStyle: textFieldLableStyle,
                textColor: blackColor,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              ContainerCustom(
                callback: pickHealthReport,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                margin: EdgeInsets.only(bottom: 15.h),
                bgColor: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: blackColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        healthReportName ?? 'Upload health report (PDF)',
                        style: TextStyle(
                          color: healthReportName != null
                              ? Colors.black
                              : Colors.grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Icon(Icons.upload_file, color: Colors.grey),
                  ],
                ),
              ),
              TextCustomWidget(
                text: 'Location',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: locationTextController,
                hintText: 'location',
                borderColor: blackColor,
                marginBottom: 30.h,
              ),
              ButtonCustom(
                text: 'Add Profile',
                margin: EdgeInsets.only(bottom: 30.h),
                callback: addNewProfile,
                dontApplyMargin: true,
                elevation: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
