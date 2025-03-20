import 'package:custom_check_box/custom_check_box.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/features/auth/presentation/pages/dog_profile_creat_page.dart';
import '../../../../custom/text_custom.dart';
import '../../../../custom/textfield_custom.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:furrpal/config/firebase_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  File? _imageFile;
  final FirebaseService _firebaseService = FirebaseService();

  bool isobscutured = false;
  bool isChecked = false;
  bool inProgress = false;
  bool isValid = false;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
        print('Image selected successfully: ${image.path}');
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select image: $e')),
      );
    }
  }

  Future<String?> _uploadImageToFirebase(String email) async {
    if (_imageFile == null) return null;

    try {
      print('Starting upload process for image: ${_imageFile!.path}');
      print('Image size: ${_imageFile!.lengthSync()} bytes');

      // Using email as a temporary identifier for the upload
      // Later we'll update it with the user's actual UID
      final String tempId = email.replaceAll('.', '_');
      print('Using temporary ID for upload: $tempId');

      final downloadUrl =
          await _firebaseService.uploadUserProfileImage(tempId, _imageFile!);

      if (downloadUrl != null) {
        print('Image successfully uploaded. Download URL: $downloadUrl');
      } else {
        print('Failed to get download URL from Firebase Storage');
      }

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  void signUp() async {
    isValid = EmailValidator.validate(emailController.text.trim());

    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
    final String fName = fNameController.text;
    final String lName = lNameController.text;
    final String address = addressController.text;
    final String phone = phoneController.text;

    final authCubit = context.read<AuthCubit>();

    bool allField = fName.isNotEmpty &&
        lName.isNotEmpty &&
        email.isNotEmpty &&
        address.isNotEmpty &&
        phone.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty;

    if (allField == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: blackColor,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r))),
          content: TextCustomWidget(
            text: 'Please Enter all fields',
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: blackColor,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r))),
          content: TextCustomWidget(
            text: 'Email is not valid',
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return;
    } else if (password == confirmPassword) {
      setState(() {
        inProgress = true;
      });

      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImageToFirebase(email);
      }

      authCubit.register(
          fName, lName, email, address, phone, password, confirmPassword,
          profileImageUrl: imageUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextCustomWidget(
            text: 'Passwords do not match',
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fNameController.dispose();
    lNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          setState(() {
            inProgress = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r))),
              content: TextCustomWidget(
                text: 'The email address is already in use by another account',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DogProfileCreatPage(),
            ),
          );
        }
      },
      child: Scaffold(
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
                height: 800.h,
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
                      text: 'First Name',
                      fontSize: 17.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    TextFieldCustom(
                      controller: fNameController,
                      marginBottom: 15.h,
                    ),
                    TextCustomWidget(
                      text: 'Last Name',
                      fontSize: 17.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    TextFieldCustom(
                      controller: lNameController,
                      marginBottom: 15.h,
                    ),
                    TextCustomWidget(
                      text: 'Email',
                      fontSize: 17.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    TextFieldCustom(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      marginBottom: 15.h,
                    ),
                    TextCustomWidget(
                      text: 'Address',
                      fontSize: 17.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    TextFieldCustom(
                      controller: addressController,
                      keyboardType: TextInputType.streetAddress,
                      marginBottom: 15.h,
                    ),
                    TextCustomWidget(
                      text: 'Mobile Number',
                      fontSize: 17.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    TextFieldCustom(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      marginBottom: 15.h,
                    ),
                    TextCustomWidget(
                      text: 'Password',
                      fontSize: 17.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    TextFieldCustom(
                      controller: passwordController,
                      marginBottom: 19.h,
                      // obscureText: isobscutured,
                      obscureText: true,
                    ),
                    TextCustomWidget(
                      text: 'Confirm Password',
                      fontSize: 17.sp,
                      marginLeft: 9.w,
                      marginBottom: 4.h,
                    ),
                    TextFieldCustom(
                      controller: confirmPasswordController,
                      marginBottom: 19.h,
                      obscureText: true,
                    ),
                    Row(
                      children: [
                        CustomCheckBox(
                          borderColor: primaryColor,
                          checkedFillColor: primaryColor,
                          value: isChecked,
                          onChanged: (index) {
                            setState(() {
                              isChecked = index;
                            });
                          },
                        ),
                        TextCustomWidget(
                          text: 'Agree with Terms & Conditions',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    ButtonCustom(
                      text: 'Continue',
                      callback: signUp,
                      inProgress: inProgress,
                      isDisabled:
                          isChecked == false ? true : false || inProgress,
                      disabledColor: inProgress == true ? primaryColor : null,
                      dontApplyMargin: true,
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
