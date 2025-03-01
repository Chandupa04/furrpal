class UserEntity {
  final String? uid;
  final String? email;
  final String? fName;
  final String? lName;

  const UserEntity({this.uid, this.email, this.fName, this.lName});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'first name': fName,
      'last name': lName,
      // 'password': password,
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> jsonUser) {
    return UserEntity(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      fName: jsonUser['first name'],
      lName: jsonUser['last name'],
      // password: jsonUser['password'],
    );
  }
}
