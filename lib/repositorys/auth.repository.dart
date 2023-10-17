// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/models/user.dart';
import 'package:ui_challenge/pages/home.dart';
import 'package:ui_challenge/utility/utils.dart';
import 'package:ui_challenge/widget/loader.dart';

class AuthRepository {
  CustomLoader loader = CustomLoader();

  Future<void> signupProcess(BuildContext context, User user) async {
    bool isExist = await Utility.checkIfUserIdExists(user.uid);
    loader.showLoader(context);

    if (isExist) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          backgroundColor: Colors.white,
          content: Container(
            alignment: Alignment.center,
            child: const Text(
              'Error Account',
              style: TextStyle(
                  fontFamily: 'icons.ttf',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await kFirestore.collection('profiles').doc(user.uid).get();

      if (userDocument.exists) {
        Map<String, dynamic> map = userDocument.data()!;
        List<String> plantId = List<String>.from(map['plantId'] ?? <String>[]);
        UserModel model = UserModel(
          userId: map['userId'],
          name: map['name'],
          profilePic: map['profilePic'],
          bio: map['bio'],
          plantsId: plantId,
        );

        await kFirestore
            .collection('profiles')
            .doc(user.uid)
            .update(model.toJson());

        await Utility.storeUserDataLocally(model).then(
          (void value) async {
            loader.hideLoader();
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute<Widget>(
                builder: (BuildContext context) => const HomePage(),
              ),
              <Route>(Route route) => false,
            );
          },
        );
      }
    } else {
      UserModel model = UserModel(
        userId: user.uid,
        profilePic: kP,
        bio: '',
        name: localUser.getString('name'),
        plantsId: <String>[],
        createdAt: DateTime.now().toUtc().toIso8601String(),
      );

      await kFirestore.collection('profiles').doc(user.uid).set(model.toJson());

      await Utility.storeUserDataLocally(model).then(
        (void value) {
          loader.hideLoader();
          Navigator.push(
            context,
            MaterialPageRoute<Widget>(
              builder: (BuildContext context) => const HomePage(),
            ),
          );
        },
      );
    }
  }
}
