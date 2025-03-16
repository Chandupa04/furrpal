import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/auth/models/user_entity.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/pages/start_page.dart';
import 'package:furrpal/features/user_profile/domain/models/profile_user.dart';
import 'package:furrpal/features/user_profile/presentation/cubit/profile_cubit.dart';
import 'package:furrpal/features/user_profile/presentation/cubit/profile_state.dart';
import 'package:furrpal/features/user_profile/presentation/pages/edit_user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../widgets/build_info_row.dart';

class UserProfile extends StatefulWidget {
  final String uid;

  const UserProfile({super.key, required this.uid});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  //cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  //current user
  late UserEntity? currentUser = authCubit.currentUser;

  // on startup
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  File? _profileImage;
  final List<String> dogs = ['Dog 1', 'Dog 2'];

  void logout() {
    final authCubit = context.read<AuthCubit>();
    authCubit.logout();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //loaded
        if (state is ProfileLoaded) {
          //get loaded user
          final user = state.profileUser;

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'My profile',
                  style: appBarStyle,
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showOptionsMenu(context, user);
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : const AssetImage('assets/images/man.jpg')
                                      as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextCustomWidget(
                                  text: '${user.fName} ${user.lName}',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  textColor: blackColor,
                                  marginBottom: 5.h,
                                ),
                                buildInfoRow(Icons.email, user.email),
                                const SizedBox(height: 4),
                                buildInfoRow(Icons.location_on, user.address),
                                const SizedBox(height: 4),
                                buildInfoRow(Icons.phone, user.phoneNumber),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Your Paws',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...dogs.map((dog) => _buildDogCard(dog)),
                            _buildAddDogCard(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: List.generate(
                          3,
                          (index) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/puppy.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          //loading
        } else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Center(
            child: Row(
              children: [
                TextCustomWidget(
                  text: 'No profile found',
                  textColor: blackColor,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      logout();
                    },
                    icon: Icon(Icons.logout))
              ],
            ),
          );
        }
      },
    );
  }

  Future<dynamic> showOptionsMenu(BuildContext context, ProfileUser user) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserProfile(user: user),
                    ),
                  );
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.settings),
              //   title: const Text('Settings'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Add settings logic here
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  logout();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartPage(),
                      ),
                      (route) => false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDogCard(String dogName) {
    return Container(
      width: 120,
      height: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/dog.jpg',
              width: 80, height: 80, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(dogName,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAddDogCard() {
    return const Icon(Icons.add, color: Colors.pink, size: 40);
  }
}
