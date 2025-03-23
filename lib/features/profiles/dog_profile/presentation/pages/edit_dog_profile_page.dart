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
  late TextEditingController weightGcontroller;
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
                        hint: Text(selectedYears.toString()),
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
                        hint: Text(selectedMonths.toString()),
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
                hintText: widget.dog.weightKg,
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
                text: 'Blood Line',
                textStyle: textFieldLableStyle,
                marginLeft: 10.w,
                marginBottom: 4.h,
              ),
              TextFieldCustom(
                controller: bloodlineTextController,
                hintText: widget.dog.bloodline,
                borderColor: blackColor,
                marginBottom: 15.h,
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
