import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/models/user.dart';

class ProfileService {
  Future<void> updateProfile(UserModel model) async {
    await kFirestore
        .collection('profiles')
        .doc(model.userId)
        .update(model.toJson());
  }

  Future<void> deleteProfile(String userId) async {
    await kFirestore.collection('profiles').doc(userId).delete();
  }
}
