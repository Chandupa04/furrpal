import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/container_custom.dart';
import 'package:furrpal/custom/text_custom.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/pages/edit_dog_profile_page.dart';
import 'package:furrpal/features/profiles/dog_profile/presentation/widgets/dog_details_card.dart';
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
      // backgroundColor: blackColor,
      appBar: AppBar(
        // backgroundColor: blackColor,
        title: Text(
          'Dog Profile',
          style: appBarStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDogProfilePage(
                    dog: widget.dog,
                  ),
                ),
              );
            },
            icon: const Icon(LucideIcons.settings),
            iconSize: 22.h,
          ),
        ],
      ),
      body: ContainerCustom(
        marginLeft: 20.w,
        marginRight: 20.w,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.dog.imageURL,
              placeholder: (context, url) => ContainerCustom(
                  width: 160.w,
                  height: 160.h,
                  child: const CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(
                Icons.person,
                size: 72.h,
                color: Colors.blue,
              ),
              imageBuilder: (context, imageProvider) => ContainerCustom(
                width: 160.w,
                height: 160.h,
                shape: BoxShape.circle,
                decorationImage: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustomWidget(
                  marginBottom: 15.h,
                  text: widget.dog.name,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w500,
                  textColor: blackColor,
                  containerAlignment: Alignment.center,
                ),
                dogDetailsCard(
                  icon: LucideIcons.hourglass,
                  title: 'Age',
                  value: widget.dog.age,
                ),
                dogDetailsCard(
                  icon: LucideIcons.venusAndMars,
                  title: 'Gender',
                  value: widget.dog.gender,
                ),
                dogDetailsCard(
                    icon: LucideIcons.weight,
                    title: 'Weight',
                    value: '${widget.dog.weightKg} ${widget.dog.weightG}'),
                dogDetailsCard(
                  icon: LucideIcons.dog,
                  title: 'Breed',
                  value: widget.dog.breed,
                ),
                dogDetailsCard(
                  icon: LucideIcons.house,
                  title: 'Location',
                  value: widget.dog.location,
                ),
                // dogDetailsCard(
                //     icon: LucideIcons.heartPulse,
                //     title: 'Health Condition',
                //     value: widget.dog.healthConditions!),
              ],
            )
          ],
        ),
      ),
    );
  }
}
