import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/features/profiles/dog_profile/domain/models/dog_entity.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/cubit/dog_profile_cubit.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/cubit/dog_profile_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../../constant/constant.dart';
import '../../../../../custom/button_custom.dart';
import '../../../../../custom/container_custom.dart';
import '../../../../../custom/text_custom.dart';
import '../../../../../custom/textfield_custom.dart';

class EditDogProfilePage extends StatefulWidget {
  final DogEntity dog;
  const EditDogProfilePage({super.key, required this.dog});

  @override
  State<EditDogProfilePage> createState() => _EditDogProfilePageState();
}

class _EditDogProfilePageState extends State<EditDogProfilePage> {
  File? selectedFile;
  bool isProcessing = false;
  String selectedGender = '';
  String selectedBreed = '';
  int? selectedYears;
  int? selectedMonths;
  String? formattedAge;
  String? recentformattedAge;

  final List<int> years = List.generate(16, (index) => index);
  final List<int> months = List.generate(12, (index) => index);

  late TextEditingController nameTextController;
  late TextEditingController locationTextController;
  late TextEditingController weightKgcontroller;
  late TextEditingController bloodlineTextController;

  @override
  void initState() {
    super.initState();
    nameTextController = TextEditingController(text: widget.dog.name);
    weightKgcontroller = TextEditingController(text: widget.dog.weightKg);
    locationTextController = TextEditingController(text: widget.dog.location);
    bloodlineTextController = TextEditingController(text: widget.dog.bloodline);

    selectedGender = widget.dog.gender;
    selectedBreed = widget.dog.breed;
    recentformattedAge = widget.dog.age;
  }

  @override
  void dispose() {
    nameTextController.dispose();
    locationTextController.dispose();
    bloodlineTextController.dispose();
    super.dispose();
  }

  // pick dog profile image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedFile = File(pickedFile.path);
      });
    }
  }

  // update dog profile details
  void updateProfile() {
    final dogProfileCubit = context.read<DogProfileCubit>();
    final dogId = widget.dog.dogId;
    formattedAge = getFormattedAge();

    dogProfileCubit.updateDogProfile(
      dogId: dogId,
      newName: nameTextController.text,
      newBreed: selectedBreed,
      newAge: formattedAge ?? recentformattedAge!,
      weightKg: weightKgcontroller.text,
      newGender: selectedGender,
      newLocation: locationTextController.text,
      bloodline: bloodlineTextController.text,
    );
  }

  // delete dog profile
  void deleteProfile() {
    final dogProfileCubit = context.read<DogProfileCubit>();
    final dogId = widget.dog.dogId;
    dogProfileCubit.deleteDogProfile(dogId);
    Navigator.pop(context);
  }

  String getFormattedAge() {
    if (selectedYears == null && selectedMonths == null) {
      return recentformattedAge!;
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
            return buildEditPage();
          }
        }, listener: (context, state) {
      if (state is DogProfileLoaded) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }

  Widget deletePopupCard() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 50.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'Delete Profile',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Are you sure you want to delete this dog profile? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: deleteProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditPage() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Edit Dog Profile',
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
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => deletePopupCard(),
                );
              },
              icon: Icon(
                LucideIcons.trash2,
                color: Colors.red,
                size: 22.sp,
              ),
            ),
          ),
        ],
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
                            imageUrl: widget.dog.imageURL,
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
                        'Tap to change photo',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      // Upload button if image is selected
                      if (selectedFile != null)
                        Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: ElevatedButton(
                            onPressed: isProcessing
                                ? null
                                : () {
                              setState(() {
                                isProcessing = true;
                              });
                              context
                                  .read<DogProfileCubit>()
                                  .updateDogProfileImage(selectedFile!, widget.dog.dogId)
                                  .then((res) {
                                setState(() {
                                  isProcessing = false;
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFBA182),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: isProcessing
                                ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text('Upload Image'),
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
                      hintText: widget.dog.name,
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
                      hintText: widget.dog.weightKg,
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
                        value: selectedGender,
                        padding: EdgeInsets.only(bottom: 15.h),
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
                        value: selectedBreed,
                        padding: EdgeInsets.only(bottom: 15.h),
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
                      hintText: widget.dog.bloodline,
                      borderColor: Colors.grey.shade300,
                      marginBottom: 15.h,
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
                      hintText: widget.dog.location,
                      borderColor: Colors.grey.shade300,
                      marginBottom: 15.h,
                    ),
                  ],
                ),
              ),

              // Save Button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: ButtonCustom(
                  text: 'Save Changes',
                  callback: updateProfile,
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
