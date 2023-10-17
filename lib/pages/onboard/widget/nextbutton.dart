import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/pages/auth/siginin/signin.dart';
import 'package:ui_challenge/pages/auth/signup/name.dart';
import 'package:ui_challenge/theme/theme.dart';

class BottomNavigationButton extends StatelessWidget {
  final int current;
  final CarouselController carouselController;
  final AnimationController controller;

  const BottomNavigationButton({
    super.key,
    required this.current,
    required this.carouselController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          if (current == 2) {
            double rotateValue = Tween<double>(begin: 0, end: 180)
                .animate(CurvedAnimation(
                  curve: Curves.easeOut,
                  parent: controller,
                ))
                .value;
            double scaleValue = Tween<double>(begin: 1.0, end: 0.5)
                .animate(CurvedAnimation(
                  curve: Curves.easeOut,
                  parent: controller,
                ))
                .value;
            double slideValue = Tween<double>(begin: 0, end: -120)
                .animate(
                  CurvedAnimation(
                    curve: Curves.easeOut,
                    parent: controller,
                  ),
                )
                .value;
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(slideValue, 0),
                  child: Transform.rotate(
                    angle: rotateValue * (3.14159265359 / 180),
                    child: Transform.scale(
                      scale: scaleValue,
                      child: child,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    sh(30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: AppColor.primary,
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute<Widget>(
                              builder: (BuildContext context) => NamePage(
                                key: key,
                                carouselController: carouselController,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Signup',
                          style: TextStyle(
                            color: AppColor.primary,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    sh(15),
                    FadeInUp(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: l(context).alreadyAccount,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 96, 96, 96),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: l(context).login,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w400,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute<Widget>(
                                      builder: (BuildContext context) =>
                                          SignInPage(
                                        key: key,
                                        carouselController: carouselController,
                                      ),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return buildButton(context);
          }
        },
        child: buildButton(context),
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return Hero(
      tag: 'back',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          carouselController.jumpToPage(current + 1);
          controller.forward(from: 0.0);
        },
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.1).animate(
            CurvedAnimation(
              curve: Curves.easeOut,
              parent: controller,
            ),
          ),
          child: RotationTransition(
            turns: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                curve: Curves.easeOut,
                parent: controller,
              ),
            ),
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primary,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
