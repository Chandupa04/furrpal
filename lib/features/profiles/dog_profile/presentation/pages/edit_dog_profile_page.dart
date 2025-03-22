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

  late TextEditingController nameTextController;
  late TextEditingController ageTextController;
  late TextEditingController locationTextController;
  late TextEditingController healthConditionTextController;

  @override
  void initState() {
    super.initState();
    nameTextController = TextEditingController(text: widget.dog.name);
    ageTextController = TextEditingController(text: widget.dog.age.toString());
    locationTextController = TextEditingController(text: widget.dog.location);
    healthConditionTextController =
        TextEditingController(text: widget.dog.healthConditions);
    selectedGender = widget.dog.gender;
    selectedBreed = widget.dog.breed;
  }

  @override
  void dispose() {
    nameTextController.dispose();
    ageTextController.dispose();
    locationTextController.dispose();
    healthConditionTextController.dispose();
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

    dogProfileCubit.updateDogProfile(
      dogId: dogId,
      newName: nameTextController.text,
      newBreed: selectedBreed,
      newAge: ageTextController.text,
      newGender: selectedGender,
      newLocation: locationTextController.text,
      newHealthConditions: healthConditionTextController.text,
    );
  }

  // delete dog profile
  void deleteProfile() {
    final dogProfileCubit = context.read<DogProfileCubit>();
    final dogId = widget.dog.dogId;
    dogProfileCubit.deleteDogProfile(dogId);
    Navigator.pop(context);
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
      shape:
          ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: ContainerCustom(
        padding:
            EdgeInsets.only(top: 10.w, bottom: 15.h, left: 10.w, right: 10.w),
        height: 100.h,
        bgColor: whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextCustomWidget(
              text: 'Are you sure you want to delete this dog profile?',
              fontSize: 18.sp,
              textColor: blackColor,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonCustom(
                  text: 'No',
                  dontApplyMargin: true,
                  btnColor: Colors.red,
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    color: whiteColor,
                  ),
                  btnHeight: 30.h,
                  btnWidth: 110.w,
                  borderRadius: BorderRadius.circular(10.r),
                  callback: () {
                    Navigator.pop(context);
                  },
                ),
                ButtonCustom(
                  text: 'Yes',
                  dontApplyMargin: true,
                  btnColor: Colors.greenAccent,
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                    color: whiteColor,
                  ),
                  btnHeight: 30.h,
                  btnWidth: 110.w,
                  borderRadius: BorderRadius.circular(10.r),
                  callback: deleteProfile,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Dog Profile',
          style: appBarStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => deletePopupCard(),
              );
            },
            icon: const Icon(LucideIcons.trash2),
            iconSize: 22.h,
          ),
        ],
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
                        imageUrl: widget.dog.imageURL,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 72.h,
                          color: Colors.black,
                        ),
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              if (selectedFile != null)
                ButtonCustom(
                  text: 'upload',
                  btnHeight: 40.h,
                  borderRadius: BorderRadius.circular(8.r),
                  margin:
                      EdgeInsets.symmetric(horizontal: 55.h, vertical: 10.h),
                  inProgress: isProcessing,
                  isDisabled: isProcessing,
                  callback: () {
                    setState(() {
                      isProcessing = true;
                    });
                    context
                        .read<DogProfileCubit>()
                        .updateDogProfileImage(selectedFile!, widget.dog.dogId);
                    //     .then((res) {
                    //   setState(() {
                    //     isProcessing = false;
                    //   });
                    //   if (res == true) {
                    //     Navigator.pop(context);
                    //     Navigator.pop(context);
                    //   }
                    // })
                  },
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
                hintText: widget.dog.name,
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
                hintText: widget.dog.age,
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
                padding: EdgeInsets.only(bottom: 15.h),
                value: selectedBreed,
                dropdownColor: whiteColor,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    // borderSide: BorderSide(color: blackColor),
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
                hintText: widget.dog.location,
                borderColor: blackColor,
                marginBottom: 15.h,
              ),
              TextCustomWidget(
                text: 'Health Condition',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: healthConditionTextController,
                hintText: widget.dog.healthConditions,
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
