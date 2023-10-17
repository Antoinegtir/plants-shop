import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/theme/theme.dart';

class DotIndactor extends StatelessWidget {
  const DotIndactor({super.key, required this.current});
  final int current;
  @override
  Widget build(BuildContext context) {
    Widget dot(int dot) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: current == dot ? Colors.white : const Color(0xffbebfc4),
            height: 7,
            width: 7,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: current == 2 ? 315 : 270),
      child: Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 100,
            height: 27,
            color: AppColor.darkGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                sw(10),
                dot(0),
                sw(10),
                dot(1),
                sw(10),
                dot(2),
                sw(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
