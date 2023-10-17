// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/pages/auth/signup/theme.dart';
import '../../../theme/theme.dart';

class NamePage extends StatefulWidget {
  const NamePage({Key? key, required this.carouselController})
      : super(key: key);
  final CarouselController carouselController;

  @override
  NamePageState createState() => NamePageState();
}

class NamePageState extends State<NamePage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  @override
  void initState() {
    _requestPermissions();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dx > 0) {
          widget.carouselController.jumpToPage(0);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: GestureDetector(
            onTap: () async {
              if (_nameController.text.isNotEmpty &&
                  _nameController.text.length < 30) {
                localUser.setString('name', _nameController.text);
                if (Platform.isIOS) {
                  HapticFeedback.mediumImpact();
                  const DarwinInitializationSettings initializationSettingsIOS =
                      DarwinInitializationSettings();
                  const InitializationSettings initializationSettings =
                      InitializationSettings(
                    iOS: initializationSettingsIOS,
                  );
                  await flutterLocalNotificationsPlugin
                      .initialize(initializationSettings);
                  const NotificationDetails notificationDetails =
                      NotificationDetails(iOS: DarwinNotificationDetails());
                  await flutterLocalNotificationsPlugin.show(
                    0,
                    'UI Challenge',
                    '${l(context).welcome} ${_nameController.text} !',
                    notificationDetails,
                  );
                } else {
                  const AndroidInitializationSettings initSettingsAndroid =
                      AndroidInitializationSettings('icons');
                  const InitializationSettings initializationSettings =
                      InitializationSettings(
                    android: initSettingsAndroid,
                  );
                  await flutterLocalNotificationsPlugin
                      .initialize(initializationSettings);
                  const AndroidNotificationDetails androidNotificationDetails =
                      AndroidNotificationDetails(
                          'your channel id', 'your channel name',
                          channelDescription: 'your channel description',
                          importance: Importance.max,
                          priority: Priority.max,
                          ticker: 'ticker');
                  const NotificationDetails notificationDetails =
                      NotificationDetails(android: androidNotificationDetails);
                  await flutterLocalNotificationsPlugin.show(
                    0,
                    'UI Challenge',
                    '${l(context).welcome} ${_nameController.text} !',
                    notificationDetails,
                  );
                }
                Navigator.push(
                  context,
                  CupertinoPageRoute<Widget>(
                    builder: (BuildContext context) =>
                        ThemePage(key: widget.key),
                  ),
                );
              }
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _nameController.text.isNotEmpty
                    ? AppColor.primary
                    : Colors.grey,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: AppColor.white,
        appBar: AppBar(
          leading: Hero(
            tag: 'back',
            child: GestureDetector(
              onTap: () {
                widget.carouselController.jumpToPage(0);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primary,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            sh(dh(context) / 13),
            FadeInUp(
              duration: const Duration(seconds: 1),
              child: FadeInRight(
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  'assets/onboard/1.png',
                  height: dh(context) / 3,
                ),
              ),
            ),
            FadeInRight(
              duration: const Duration(seconds: 1),
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: TextField(
                  cursorColor: Colors.blue,
                  cursorHeight: 70,
                  textAlign: TextAlign.center,
                  onChanged: (String value) {
                    setState(() {});
                  },
                  keyboardAppearance: Brightness.dark,
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: l(context).name,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Container(
              height: dh(context) / 10,
            ),
          ],
        ),
      ),
    );
  }
}
