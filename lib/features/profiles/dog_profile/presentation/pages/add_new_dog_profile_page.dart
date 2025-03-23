import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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

  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController ageTextController = TextEditingController();
  final TextEditingController weightKgcontroller = TextEditingController();
  final TextEditingController weightGcontroller = TextEditingController();
  final TextEditingController locationTextController = TextEditingController();
  final TextEditingController bloodlineTextController = TextEditingController();
  // final TextEditingController healthReportController = TextEditingController();

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

  void addNewProfile() async {
    final dogProfileCubit = context.read<DogProfileCubit>();

    final String name = nameTextController.text;
    final String age = ageTextController.text;
    final String weightKg = weightKgcontroller.text;
    final String weightG = weightGcontroller.text;
    final String location = locationTextController.text;
    // final String healthCondition = healthConditionTextController.text;
    final String bloodline = bloodlineTextController.text;
    // final String healthReport = healthReportController.text;

    if (name.isEmpty ||
        age.isEmpty ||
        location.isEmpty ||
        weightKg.isEmpty ||
        weightG.isEmpty ||
        bloodline.isEmpty ||
        // healthReport.isEmpty ||
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
        age: age,
        weightKg: weightKg,
        weightG: weightG,
        breed: selectedBreed!,
        gender: selectedGender!,
        location: location,
        bloodline: bloodline,
        // healthReportUrl: healthReport,
      );
    }
  }

  @override
  void dispose() {
    nameTextController.dispose();
    ageTextController.dispose();
    locationTextController.dispose();
    weightKgcontroller.dispose();
    weightGcontroller.dispose();
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
                marginTop: 10.h,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: ageTextController,
                hintText: 'age',
                keyboardType: TextInputType.number,
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'weight (Kg)',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginTop: 10.h,
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
                text: 'weight (G)',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginTop: 10.h,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: weightGcontroller,
                hintText: 'weightG',
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
                  textColor: blackColor,
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
                  textColor: blackColor,
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
                text: 'Location',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: locationTextController,
                hintText: 'location',
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'Blood Line',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: bloodlineTextController,
                hintText: 'Blood Line',
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
