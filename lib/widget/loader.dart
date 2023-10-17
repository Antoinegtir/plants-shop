import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ui_challenge/constant/const.dart';

class CustomLoader {
  static CustomLoader? _customLoader;

  CustomLoader._createObject();

  factory CustomLoader() {
    if (_customLoader != null) {
      return _customLoader!;
    } else {
      _customLoader = CustomLoader._createObject();
      return _customLoader!;
    }
  }

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  _buildLoader() {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return buildLoader(context);
      },
    );
  }

  showLoader(BuildContext context) {
    _overlayState = Overlay.of(context);
    _buildLoader();
    _overlayState!.insert(_overlayEntry!);
  }

  hideLoader() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      e;
    }
  }

  buildLoader(BuildContext context, {Color? backgroundColor}) {
    return const CustomScreenLoader();
  }
}

class CustomScreenLoader extends StatelessWidget {
  const CustomScreenLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: dh(context),
          width: dw(context),
          color: Colors.black.withOpacity(0),
          child: Lottie.asset('assets/animation/1.json'),
        ),
      ),
    );
  }
}
