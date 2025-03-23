import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/models/user_entity.dart';
import '../domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity?> loginwithEmailPassword(
      String email, String password) async {
    try {
      // Attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      UserEntity user = UserEntity(
        uid: userCredential.user!.uid,
        email: email,
        fName: '',
        lName: '',
        phoneNumber: '',
        address: '',
      );

      return user;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<UserEntity?> registerwithEmailPassword(
      String fName,
      String lName,
      String email,
      String address,
      String phone,
      String password,
      String confirmPassword) async {
    try {
      // Attempt sign in
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseuser = userCredential.user!;
      await firebaseuser.sendEmailVerification();

      UserEntity user = UserEntity(
        uid: userCredential.user!.uid,
        email: email,
        fName: fName,
        lName: lName,
        address: address,
        phoneNumber: phone,
        createdAt: Timestamp.now(),
      );

      // Save the data to Firestore with an empty cart array
      await firebaseFirestore.collection('users').doc(user.uid).set({
        ...user.toJson(), // Spread existing user data
        'cart': [], // Initialize cart as an empty array
      });

      return user;
    } catch (e) {
      throw Exception('Registration Failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // Get current logged-in user from Firebase
    final firebaseUser = firebaseAuth.currentUser;

    // No user logged in
    if (firebaseUser == null) {
      return null;
    }

    // User exists
    return UserEntity(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      fName: '',
      lName: '',
      phoneNumber: '',
      address: '',
    );
  }

  @override
  Future<void> verifyEmail() async {
    final user = firebaseAuth.currentUser!;
    await user.sendEmailVerification();
  }
}
