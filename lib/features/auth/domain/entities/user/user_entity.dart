class UserEntity {
  final String? uid;
  final String? email;
  final String? fName;
  final String? lName;
  final String? phoneNumber;
  final String? address;

  const UserEntity(
      {this.uid,
      this.email,
      this.fName,
      this.lName,
      this.phoneNumber,
      this.address});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'first name': fName,
      'last name': lName,
      'phone number': phoneNumber,
      'address': address,
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
    );
  }
}
