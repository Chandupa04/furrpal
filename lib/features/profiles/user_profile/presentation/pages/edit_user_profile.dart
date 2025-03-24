import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/custom/textfield_custom.dart';
import 'package:furrpal/features/profiles/user_profile/domain/models/profile_user.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/cubit/profile_cubit.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/cubit/profile_state.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfile extends StatefulWidget {
  final ProfileUser user;
  const EditUserProfile({super.key, required this.user});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  late TextEditingController fNameTextController;
  late TextEditingController lNameTextController;
  late TextEditingController bioTextController;
  late TextEditingController addressTextController;
  late TextEditingController phoneNumTextController;

  File? selectedFile;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    fNameTextController = TextEditingController(text: widget.user.fName);
    lNameTextController = TextEditingController(text: widget.user.lName);
    phoneNumTextController =
        TextEditingController(text: widget.user.phoneNumber);
    bioTextController = TextEditingController(text: widget.user.bio);
    addressTextController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    fNameTextController.dispose();
    lNameTextController.dispose();
    phoneNumTextController.dispose();
    bioTextController.dispose();
    addressTextController.dispose();
    super.dispose();
  }

  //add image picker
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

  void updateProfile() {
    final profileCubit = context.read<ProfileCubit>();
    final String uid = widget.user.uid;

    profileCubit.updateUserProfile(
      uid: uid,
      newFName: fNameTextController.text,
      newLName: lNameTextController.text,
      newPhoneNumber: phoneNumTextController.text,
      newBio: bioTextController.text,
      newAddress: addressTextController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // profile loading
        if (state is ProfileLoading) {
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
          //edit form
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
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
          'Edit Profile',
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
                          imageUrl: widget.user.profileImageUrl,
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
                            bgColor: Colors.white.withOpacity(0.3),
                            child: Icon(
                              Icons.person,
                              size: 72.h,
                              color: Colors.white,
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
                      'Tap to change profile picture',
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
                                .read<ProfileCubit>()
                                .uploadProfilePicture(
                                selectedFile!, widget.user.uid)
                                .then((res) {
                              setState(() {
                                isProcessing = false;
                              });
                              if (res == true) {
                                Navigator.pop(context);
                              }
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

            // Form Fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              Icons.person_outline,
                              color: const Color(0xFFFBA182),
                              size: 22.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Personal Information',
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

                        // First Name
                        Text(
                          'First Name',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFieldCustom(
                          controller: fNameTextController,
                          hintText: widget.user.fName,
                          borderColor: Colors.grey.shade300,
                          marginBottom: 15.h,
                        ),

                        // Last Name
                        Text(
                          'Last Name',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFieldCustom(
                          controller: lNameTextController,
                          hintText: widget.user.lName,
                          borderColor: Colors.grey.shade300,
                          marginBottom: 15.h,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Contact Information Card
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
                              Icons.contact_phone,
                              color: const Color(0xFFFBA182),
                              size: 22.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Contact Information',
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

                        // Address
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFieldCustom(
                          controller: addressTextController,
                          hintText: widget.user.address,
                          keyboardType: TextInputType.streetAddress,
                          borderColor: Colors.grey.shade300,
                          marginBottom: 15.h,
                        ),

                        // Phone Number
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFieldCustom(
                          controller: phoneNumTextController,
                          hintText: widget.user.phoneNumber,
                          keyboardType: TextInputType.phone,
                          borderColor: Colors.grey.shade300,
                          marginBottom: 15.h,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Bio Card
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
                              Icons.description,
                              color: const Color(0xFFFBA182),
                              size: 22.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'About Me',
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

                        // Bio - Removed maxLines parameter that was causing the error
                        Text(
                          'Bio',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextFieldCustom(
                          controller: bioTextController,
                          hintText: widget.user.bio,
                          borderColor: Colors.grey.shade300,
                          marginBottom: 15.h,
                          // Removed maxLines parameter that was causing the error
                        ),
                      ],
                    ),
                  ),

                  // Save Button - Using ButtonCustom instead of ElevatedButton to ensure it's visible
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
                      dontApplyMargin: false,
                    ),
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
