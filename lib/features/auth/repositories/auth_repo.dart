import '../models/user_entity.dart';

abstract class AuthRepo {
  //Credentials
  Future<UserEntity?> loginwithEmailPassword(String email, String password);

  Future<UserEntity?> registerwithEmailPassword(
      String fName,
      String lName,
      String email,
      String address,
      String phone,
      String password,
      String confirmPassword,
      {String? profileImageUrl});

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();
}
