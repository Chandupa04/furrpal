import 'package:furrpal/features/auth/domain/entities/user/user_entity.dart';

class ProfileUser extends UserEntity {
  final String profileImageUrl;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.fName,
    required super.lName,
    required super.phoneNumber,
    required super.address,
    required this.profileImageUrl,
  });

  // update the profile
  ProfileUser copyWith({String? newProfileImageUrl}) {
    return ProfileUser(
      uid: uid,
      email: email,
      fName: fName,
      lName: lName,
      phoneNumber: phoneNumber,
      address: address,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'uid': uid,
      'email': email,
      'first name': fName,
      'last name': lName,
      'phone number': phoneNumber,
      'address': address,
      'profile image url': profileImageUrl,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> jsonUser) {
    return ProfileUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      fName: jsonUser['first name'],
      lName: jsonUser['last name'],
      phoneNumber: jsonUser['phone number'],
      address: jsonUser['address'],
      profileImageUrl: jsonUser['profileImageUrl'] ?? '',
    );
  }
}
