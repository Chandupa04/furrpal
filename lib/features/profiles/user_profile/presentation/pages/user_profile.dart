import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/auth/domain/models/user_entity.dart';
import 'package:furrpal/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furrpal/features/auth/presentation/pages/start_page.dart';
import 'package:furrpal/features/profiles/dog_profile/domain/models/dog_entity.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/cubit/dog_profile_cubit.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/cubit/dog_profile_state.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/pages/add_new_dog_profile_page.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/pages/dog_profile_page.dart';
import 'package:furrpal/features/profiles/post/presentation/cubit/post_cubit.dart';
import 'package:furrpal/features/profiles/user_profile/domain/models/profile_user.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/cubit/profile_cubit.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/cubit/profile_state.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/pages/edit_user_profile.dart';
import 'package:furrpal/features/profiles/user_profile/presentation/widgets/user_post_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../post/data/post_repo_impl.dart';
import '../../../post/presentation/cubit/post_state.dart';
import '../widgets/build_info_row.dart';

class UserProfile extends StatefulWidget {
  final String uid;

  const UserProfile({super.key, required this.uid});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // post repo
  final postRepo = PostRepoImpl();
  //cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  late final dogProfileCubit = context.read<DogProfileCubit>();
  // late final postCubit = context.read<PostCubit>();

  //current user
  late UserEntity? currentUser = authCubit.currentUser;

  // on startup
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
    // load dog profile data
    dogProfileCubit.fetchDogProfiles();
    // load user post data
    // postCubit.fetchUserPost();
  }

  void logout() {
    final authCubit = context.read<AuthCubit>();
    authCubit.logout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(postRepo: postRepo)..fetchUserPost(),
      lazy: false,
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          //loaded
          if (state is ProfileLoaded) {
            //get loaded user
            final user = state.profileUser;

            return SafeArea(
              child: Scaffold(
                backgroundColor: const Color(0xFFF8F9FA),
                appBar: AppBar(
                  backgroundColor: const Color(0xFFF8F9FA),
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    Container(
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.black),
                        onPressed: () {
                          showOptionsMenu(context, user);
                        },
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Profile Image
                            Center(
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
                                child: CachedNetworkImage(
                                  imageUrl: user.profileImageUrl,
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
                            SizedBox(height: 16.h),
                            // User Name
                            Center(
                              child: Text(
                                '${user.fName} ${user.lName}',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // User Info Cards
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Contact Info Card
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
                                  buildInfoRow(Icons.email, user.email),
                                  SizedBox(height: 8.h),
                                  buildInfoRow(Icons.location_on, user.address),
                                  SizedBox(height: 12.h),
                                  buildInfoRow(Icons.phone, user.phoneNumber),
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
                                        Icons.person_outline,
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
                                  Text(
                                    user.bio,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // My Paws Section
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.pets,
                                        color: const Color(0xFFFBA182),
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        'My Paws',
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF9A4CAF).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddNewDogProfilePage(),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: const Color(0xFFFBA182),
                                        size: 24.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            BlocBuilder<DogProfileCubit, DogProfileState>(
                              builder: (context, state) {
                                if (state is DogProfileLoaded) {
                                  final dogs = state.dogEntity;
                                  return SizedBox(
                                    height: 180.h,
                                    child: dogs.isEmpty
                                        ? Center(
                                      child: Text(
                                        'No pets added yet. Add your first pet!',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                        : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: dogs.length,
                                      itemBuilder: (context, index) => _buildDogCard(dogs[index]),
                                    ),
                                  );
                                } else if (state is DogProfileLoading) {
                                  return SizedBox(
                                    height: 180.h,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),

                            // Gallery Section
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    color: const Color(0xFFFBA182),
                                    size: 24.sp,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            BlocBuilder<PostCubit, PostState>(
                              builder: (context, state) {
                                if (state is PostLoaded) {
                                  final posts = state.postEntity;
                                  return posts.isEmpty
                                      ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 30.h),
                                      child: Text(
                                        'No posts yet. Share your first moment!',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                      : ListView.builder(
                                    itemCount: posts.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: UserPostCard(
                                        post: posts[index],
                                      ),
                                    ),
                                  );
                                } else if (state is PostLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),

                            // Bottom padding
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            //loading
          } else if (state is ProfileLoading) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xFF9A4CAF),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Loading profile...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60.sp,
                      color: Colors.red.shade300,
                    ),
                    SizedBox(height: 16.h),
                    const TextCustomWidget(
                      text: 'No profile found',
                      textColor: blackColor,
                      fontSize: 18,
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StartPage(),
                            ),
                                (route) => false);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBA182),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> showOptionsMenu(BuildContext context, ProfileUser user) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBA182).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: const Color(0xFFFBA182),
                      size: 24.sp,
                    ),
                  ),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 24.sp,
                    ),
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    logout();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartPage(),
                        ),
                            (route) => false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDogCard(DogEntity dog) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DogProfilePage(dog: dog),
          ),
        );
      },
      child: Container(
        width: 150.w,
        margin: EdgeInsets.only(right: 16.w),
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
            // Dog Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: CachedNetworkImage(
                imageUrl: dog.imageURL,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 120.h,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 120.h,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.pets,
                    size: 40.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // Dog Name
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dog.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    dog.breed,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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