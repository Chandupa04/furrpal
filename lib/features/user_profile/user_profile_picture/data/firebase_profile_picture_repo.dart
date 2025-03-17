import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:furrpal/features/user_profile/user_profile_picture/domain/profile_picture_repo.dart';

class FirebaseProfilePictureRepo implements ProfilePictureRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadProfilePicture(String path, String fileName) {
    return _uploadPicture(path, fileName, 'profile_pictures');
  }

  //upload profile picture to storage

  Future<String?> _uploadPicture(
      String path, String fileName, String folder) async {
    try {
      final file = File(path);
      final storageRef = storage.ref().child('$folder/$fileName');
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
