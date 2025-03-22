import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String uid;
  final String email;
  final String fName;
  final String lName;
  final String phoneNumber;
  final String address;
  final Timestamp? createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.fName,
    required this.lName,
    required this.phoneNumber,
    required this.address,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'first name': fName,
      'last name': lName,
      'phone number': phoneNumber,
      'address': address,
      'created_at': createdAt,
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> jsonUser) {
    return UserEntity(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      fName: jsonUser['first name'],
      lName: jsonUser['last name'],
      phoneNumber: jsonUser['phone number'],
      address: jsonUser['address'],
      createdAt: jsonUser['created_at'],
    );
  }
}
