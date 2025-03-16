import 'package:flutter/material.dart';
import 'package:furrpal/features/user_profile/domain/models/profile_user.dart';

class EditUserProfile extends StatefulWidget {
  final ProfileUser user;
  const EditUserProfile({super.key, required this.user});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
