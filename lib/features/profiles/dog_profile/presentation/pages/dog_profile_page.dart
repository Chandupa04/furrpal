import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/cubit/dog_profile_cubit.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/cubit/dog_profile_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/models/dog_entity.dart';

class DogProfilePage extends StatefulWidget {
  final DogEntity dog;
  const DogProfilePage({super.key, required this.dog});

  @override
  State<DogProfilePage> createState() => _DogProfilePageState();
}

class _DogProfilePageState extends State<DogProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Profile'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Icon(LucideIcons.dog),
              TextCustomWidget(
                text: 'Name',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                textColor: blackColor,
              ),
              TextCustomWidget(
                text: widget.dog.name,
                textColor: blackColor,
              ),
            ],
          ),
          Row(
            children: [
              Icon(LucideIcons.venusAndMars),
              TextCustomWidget(
                text: widget.dog.breed,
                textColor: blackColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
