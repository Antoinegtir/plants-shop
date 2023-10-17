import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ui_challenge/constant/const.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({super.key, required this.current, required this.model});
  final int current;
  final Map<String, dynamic> model;

  String formatSentence(String text) {
    return '${text.toString().split(' ').sublist(0, model['text'].toString().split(' ').length - 1).join(' ')} ';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        sh(dh(context) / 7),
        SizedBox(
          height: dh(context) / 2.5,
          width: dw(context) / 1.2,
          child: FadeIn(
            duration: const Duration(seconds: 1),
            child: Lottie.asset(
              "assets/animation/${model["image"]}",
              fit: BoxFit.contain,
            ),
          ),
        ),
        sh(50),
        FadeInUp(
          child: FadeInLeft(
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: formatSentence(model['text']),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 40,
                    ),
                  ),
                  TextSpan(
                    text: model['text'].toString().split(' ').last,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
