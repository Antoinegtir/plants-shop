import 'package:animate_do/animate_do.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/pages/home.dart';
import 'package:ui_challenge/services/auth.service.dart';
import 'package:ui_challenge/utility/utils.dart';
import '../../../theme/theme.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  Widget _customButton(
    Function()? function,
    String text,
    IconData icon,
  ) {
    Color color =
        !localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1,
            color: color,
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
                color: color,
                size: 28,
              ),
              sw(10),
              Text(
                text,
                style: TextStyle(color: color, fontSize: 23),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    Color rcolor =
        !localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    AuthService state = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
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
              padding: EdgeInsets.only(bottom: dh(context) / 5),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Signup',
                      style: TextStyle(
                          color: rcolor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    sh(20),
                    _customButton(
                      () {
                        state.googleSign(context);
                      },
                      'Google',
                      FontAwesomeIcons.google,
                    ),
                    _customButton(
                      () {
                        localUser.setString(
                          'user_id',
                          Utility.generateRandomUserId(),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute<Widget>(
                            builder: (BuildContext context) => const HomePage(),
                          ),
                          <Route>(Route route) => false,
                        );
                      },
                      ' ${l(context).anonym}',
                      FontAwesomeIcons.mask,
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
