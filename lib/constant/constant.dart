import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color primaryColor = Color(0xffFDA283);
const Color whiteColor = Color(0xffFFFFFF);
const Color postColor = Color(0xffFFDACD);
const Color blackColor = Color(0xff000000);

const Gradient primaryGradient = LinearGradient(
  colors: [
    Color(0xffFDA283),
    Color(0xffFFDACD),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const String logoImage = 'assets/images/logo.png';

TextStyle appBarStyle = TextStyle(
  fontSize: 24.sp,
  fontWeight: FontWeight.w700,
  color: blackColor,
);

TextStyle textFieldLableStyle = TextStyle(
  fontSize: 17.sp,
  color: blackColor,
);

final List<String> breeds = [
  'Afghan Hound',
  'American Bully',
  'American Staffordshire Terrier',
  'Basset Hound',
  'Beagle',
  'Belgian Malinois',
  'Border Collie',
  'Boxer',
  'Bulldog',
  'Chihuahua',
  'Cocker Spaniel',
  'Dalmatian',
  'Dachshund',
  'Doberman',
  'French Bulldog',
  'German Shepherd',
  'German Spitz',
  'Golden Retriever',
  'Great Dane',
  'Great Pyrenees',
  'Indian Pariah Dog (Desi Dog)',
  'Jack Russell Terrier',
  'Japanese Spitz',
  'Labrador Retriever',
  'Lhasa Apso',
  'Maltese',
  'Mixed Breed (Mongrel)',
  'Pekingese',
  'Pomeranian',
  'Poodle',
  'Pug',
  'Rottweiler',
  'Saint Bernard',
  'Samoyed',
  'Shih Tzu',
  'Siberian Husky',
  'Spitz',
  'Sri Lankan Hound',
  'Sri Lankan Mastiff',
  'Terrier',
  'Tibetan Mastiff',
  'Weimaraner',
  'Whippet'
];

final List<String> genders = ['Male', 'Female'];
final List<String> weights = ['Male', 'Female'];