import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:furrpal/features/auth/domain/entities/user/user_entity.dart';
import 'package:furrpal/features/auth/domain/repositories/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity?> loginwithEmailPassword(
      String email, String password) async {
    try {
      //attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      UserEntity user = UserEntity(
        uid: userCredential.user!.uid,
        email: email,
        fName: '',
        lName: '',
      );

      return user;

      //catch any error
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<UserEntity?> registerwithEmailPassword(String fName, String lName,
      String email, String password, String confirmPassword) async {
    try {
      //attempt sign in
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserEntity user = UserEntity(
        uid: userCredential.user!.uid,
        email: email,
        fName: fName,
        lName: lName,
      );

      //save the data to database
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());

      return user;

      //catch any error
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    //get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;

    //no user logged in
    if (firebaseUser == null) {
      return null;
    }

    //user exsist
    return UserEntity(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      fName: '',
      lName: '',
    );
  }
}
