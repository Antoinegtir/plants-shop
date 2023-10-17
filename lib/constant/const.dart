import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_challenge/models/user.dart';

// [NOTIFICATION] handler
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// [INTERNATIONALIZATION] handler
AppLocalizations l(BuildContext context) {
  return AppLocalizations.of(context)!;
}

// [FIREBASE] handler
final FirebaseFirestore kFirestore = FirebaseFirestore.instance;
final FirebaseAuth kAuth = FirebaseAuth.instance;
final Reference kStorage = FirebaseStorage.instance.ref();
final FirebaseAnalytics kAnalytics = FirebaseAnalytics.instance;

// [USER] handler
final GoogleSignIn kGoogle = GoogleSignIn();
final UserModel model = UserModel();
late SharedPreferences localUser;

// [GRAPHICAL INTERFACE] handler
Widget sh(double val) {
  return SizedBox(height: val);
}

Widget sw(double val) {
  return SizedBox(width: val);
}

double dh(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double dw(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// [DEFAULT PROFILE PIC]
String kP =
    'https://cdn.vectorstock.com/i/preview-1x/20/76/man-avatar-profile-vector-21372076.jpg';
