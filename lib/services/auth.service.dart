// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ui_challenge/repositorys/auth.repository.dart';

class AuthService {
  void googleSign(BuildContext context) async {
    AuthRepository state = Provider.of<AuthRepository>(context, listen: false);

    HapticFeedback.heavyImpact();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await kAuth.signInWithCredential(credential);
    User user = userCredential.user!;
    kAnalytics.logSignUp(signUpMethod: 'Google Register');
    await state.signupProcess(context, user);
  }
}
