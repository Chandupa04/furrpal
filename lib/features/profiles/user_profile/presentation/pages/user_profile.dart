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
                appBar: AppBar(
                  surfaceTintColor: whiteColor,
                  automaticallyImplyLeading: false,
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
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: user.profileImageUrl,
                              placeholder: (context, url) => ContainerCustom(
                                width: 120.w,
                                height: 100.h,
                                child: const CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 72.h,
                                color: Colors.grey,
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  ContainerCustom(
                                width: 120.w,
                                height: 100.h,
                                shape: BoxShape.circle,
                                decorationImage: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
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
                        TextCustomWidget(
                          text: 'Bio',
                          marginTop: 10.h,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          textColor: blackColor,
                        ),
                        TextCustomWidget(
                          text: user.bio,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          textColor: blackColor,
                        ),

                        // my paws section
                        TextCustomWidget(
                          text: 'My Paws',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          textColor: blackColor,
                        ),

                        const SizedBox(height: 16),
                        BlocBuilder<DogProfileCubit, DogProfileState>(
                            builder: (context, state) {
                          if (state is DogProfileLoaded) {
                            final dogs = state.dogEntity;
                            return ContainerCustom(
                              alignment: Alignment.centerLeft,
                              height: 130.h,
                              child: ListView(
                                clipBehavior: Clip.none,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: dogs.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        _buildDogCard(dogs[index]),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddNewDogProfilePage(),
                                        ),
                                      );
                                    },
                                    color: primaryColor,
                                    iconSize: 25.h,
                                    icon: const Icon(LucideIcons.cross),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is DogProfileLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return const SizedBox();
                        }),
                        const SizedBox(height: 32),

                        // gallery section
                        TextCustomWidget(
                          text: 'Post Gallery',
                          fontSize: 24.sp,
                          textColor: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<PostCubit, PostState>(
                          builder: (context, state) {
                            if (state is PostLoaded) {
                              final posts = state.postEntity;
                              return ListView.builder(
                                itemCount: posts.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => UserPostCard(
                                  post: posts[index],
                                ),
                              );
                            } else if (state is PostLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return SizedBox();
                          },
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextCustomWidget(
                    text: 'No profile found',
                    textColor: blackColor,
                  ),
                  IconButton(
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
                      icon: const Icon(Icons.logout))
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> showOptionsMenu(BuildContext context, ProfileUser user) {
    return showModalBottomSheet(
      backgroundColor: whiteColor,
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
                        builder: (context) => const StartPage(),
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

  Widget _buildDogCard(DogEntity dog) {
    return ContainerCustom(
      callback: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DogProfilePage(dog: dog),
          ),
        );
      },
      shadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 3.h),
        ),
      ],
      width: 120.w,
      height: 130.h,
      padding: EdgeInsets.all(10.w),
      marginRight: 12.w,
      bgColor: postColor,
      borderRadius: BorderRadius.circular(10.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: dog.imageURL,
            placeholder: (context, url) => ContainerCustom(
                width: 80.w,
                height: 80.h,
                child: const CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              size: 72.h,
              color: Colors.blue,
            ),
            imageBuilder: (context, imageProvider) => ContainerCustom(
              width: 95.w,
              height: 80.h,
              borderRadius: BorderRadius.circular(10.r),
              clipBehavior: Clip.hardEdge,
              decorationImage: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          TextCustomWidget(
            text: dog.name.toUpperCase(),
            fontSize: 16.sp,
            marginTop: 10.h,
            containerAlignment: Alignment.center,
            textColor: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
