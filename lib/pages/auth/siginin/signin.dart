import 'package:animate_do/animate_do.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/services/auth.service.dart';
import 'package:ui_challenge/theme/theme.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.carouselController});
  final CarouselController carouselController;

  Widget _customButton(
    Function()? function,
    String text,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1,
            color: AppColor.secondary,
          ),
        ),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: function,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: AppColor.secondary,
                size: 28,
              ),
              sw(10),
              Text(
                text,
                style: const TextStyle(color: AppColor.secondary, fontSize: 23),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            carouselController.jumpToPage(0);
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Hero(
              tag: 'back',
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
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 0) {
            carouselController.jumpToPage(0);
            Navigator.pop(context);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            sh(20),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Align(
                alignment: Alignment.topCenter,
                child: FadeInLeft(
                  duration: const Duration(seconds: 1),
                  child: FadeInDown(
                    duration: const Duration(seconds: 1),
                    child: Transform.scale(
                      scale: 0.7,
                      child: Image.asset(
                        'assets/onboard/2.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: dh(context) / 3),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    sh(20),
                    _customButton(
                      () {
                        AuthService state =
                            Provider.of<AuthService>(context, listen: false);
                        state.googleSign(context);
                      },
                      'Google',
                      FontAwesomeIcons.google,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
