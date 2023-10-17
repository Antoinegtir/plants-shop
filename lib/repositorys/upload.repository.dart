import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadRepository {
  Future<String> uploadProfileImage(String userName, File imageFile) async {
    try {
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile/$userName/profile_pic.png');
      UploadTask uploadTask = storageRef.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      return '';
    }
  }

  Future<String> uploadPlants(File imageFile) async {
    try {
      String time = DateTime.now().toUtc().toIso8601String();
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('plants/$time.png');
      UploadTask uploadTask = storageRef.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      return '';
    }
  }
}
