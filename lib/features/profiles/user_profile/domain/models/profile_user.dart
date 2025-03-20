import '../../../../auth/models/user_entity.dart';

class ProfileUser extends UserEntity {
  final String profileImageUrl;
  final String bio;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.fName,
    required super.lName,
    required super.phoneNumber,
    required super.address,
    required this.profileImageUrl,
    required this.bio,
  });

  // update the profile
  ProfileUser copyWith({
    String? newProfileImageUrl,
    String? newFName,
    String? newLName,
    String? newBio,
    String? newAddress,
    String? newPhoneNumber,
  }) {
    return ProfileUser(
      uid: uid,
      email: email,
      fName: newFName ?? fName,
      lName: newLName ?? lName,
      phoneNumber: newPhoneNumber ?? phoneNumber,
      address: newAddress ?? address,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      bio: newBio ?? bio,
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
      'bio': bio,
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
      bio: jsonUser['bio'] ?? '',
    );
  }
}
