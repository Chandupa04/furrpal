class UserEntity {
  final String? uid;
  final String? email;
  final String? name;

  // will not going to firebase
  final String? password;

  const UserEntity({
    this.uid,
    this.email,
    this.name,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      // 'password': password,
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> jsonUser) {
    return UserEntity(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      // password: jsonUser['password'],
    );
  }
}
