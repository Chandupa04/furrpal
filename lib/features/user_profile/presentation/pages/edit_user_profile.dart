import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/custom/textfield_custom.dart';
import 'package:furrpal/features/user_profile/domain/models/profile_user.dart';
import 'package:furrpal/features/user_profile/presentation/cubit/profile_cubit.dart';
import 'package:furrpal/features/user_profile/presentation/cubit/profile_state.dart';

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
  PlatformFile? imagePickedFile;

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fNameTextController = TextEditingController(text: widget.user.fName);
    lNameTextController = TextEditingController(text: widget.user.lName);
    phoneNumTextController =
        TextEditingController(text: widget.user.phoneNumber);
    bioTextController = TextEditingController(text: widget.user.bio);
    addressTextController = TextEditingController(text: widget.user.address);
    // imagePickedFile = PlatformFile(name: widget.user.profileImageUrl, size: 1);
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

  void updateProfile() {
    final profileCubit = context.read<ProfileCubit>();
    final String uid = widget.user.uid;

    if (fNameTextController.text.isNotEmpty ||
        lNameTextController.text.isNotEmpty ||
        phoneNumTextController.text.isNotEmpty ||
        bioTextController.text.isNotEmpty ||
        addressTextController.text.isNotEmpty ||
        imagePickedFile != null) {
      profileCubit.updateUserProfile(
        uid: uid,
        newFName: fNameTextController.text,
        newLName: lNameTextController.text,
        newPhoneNumber: phoneNumTextController.text,
        newBio: bioTextController.text,
        newAddress: addressTextController.text,
        profileImagePath: imagePickedFile?.path,
      );
    } else {
      Navigator.pop(context);
    }
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
                Center(child: CircularProgressIndicator()),
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
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
                child: (imagePickedFile != null)
                    ? Image.file(
                        File(imagePickedFile!.path!),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.user.profileImageUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 72.h,
                          color: Colors.blue,
                        ),
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              TextCustomWidget(
                text: 'First Name',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginTop: 10.h,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: fNameTextController,
                hintText: widget.user.fName,
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'Last Name',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: lNameTextController,
                hintText: widget.user.lName,
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'Address',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: addressTextController,
                hintText: widget.user.address,
                keyboardType: TextInputType.streetAddress,
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'Phone Number',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: phoneNumTextController,
                hintText: widget.user.phoneNumber,
                keyboardType: TextInputType.phone,
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'Bio',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: bioTextController,
                hintText: widget.user.bio,
                borderColor: blackColor,
                marginBottom: 30.h,
              ),
              ButtonCustom(
                text: 'Save Edit',
                callback: updateProfile,
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
