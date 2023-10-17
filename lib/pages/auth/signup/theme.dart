// ignore_for_file: must_be_immutable
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/pages/auth/signup/signup.dart';
import 'package:ui_challenge/theme/theme.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});
  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> with TickerProviderStateMixin {
  bool isDarkmode = false;
  late AnimationController bounceController;
  late AnimationController zoomController;
  late AnimationController slideController;
  late AnimationController rotateController;

  @override
  void initState() {
    super.initState();
    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    slideController.dispose();
    rotateController.dispose();
    zoomController.dispose();
    bounceController.dispose();
    super.dispose();
  }

  Widget _customButton(
    Animation<double> controller,
    Function()? function,
    String text,
  ) {
    return ScaleTransition(
      scale: controller,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1,
            color: AppColor.white,
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
          child: Text(
            text,
            style: TextStyle(color: AppColor.white),
          ),
        ),
      ),
    );
  }

  Widget _customAnimatedContainer(
      AnimationController controller, bool isDarkmode, int val) {
    return RotationTransition(
      turns: Tween<double>(begin: 0, end: isDarkmode ? -0.03 : 0.03).animate(
        CurvedAnimation(
          curve: Curves.easeOut,
          parent: controller,
        ),
      ),
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle:
                isDarkmode ? -0.02 * controller.value : 0.02 * controller.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 280,
              width: dw(context) / 3.2,
              decoration: BoxDecoration(
                color: val == 1 ? AppColor.secondary : AppColor.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: StaggeredGridView.countBuilder(
                physics: const NeverScrollableScrollPhysics(),
                staggeredTileBuilder: (int index) =>
                    const StaggeredTile.count(1, 1.51),
                crossAxisCount: 2,
                padding: const EdgeInsets.only(left: 10, right: 10),
                itemCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemBuilder: (BuildContext context, int index) {
                  if (index % 2 == 0) {
                    if (index == 0) {
                      return FadeInUp(
                        duration: const Duration(seconds: 1),
                        child: Transform.translate(
                          offset: const Offset(0.0, 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: val == 0 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }
                    return FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: Transform.translate(
                        offset: const Offset(0.0, 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: val == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return FadeInDown(
                      duration: const Duration(seconds: 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            color: val == 0 ? Colors.white : Colors.black),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            if (localUser.getBool('darkmode') == null) {
              localUser.setBool('darkmode', false);
            }
            Navigator.push(
              context,
              CupertinoPageRoute<Widget>(
                builder: (BuildContext context) => const SignupPage(),
              ),
            );
          },
          child: Hero(
            tag: 'back',
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColor.primary),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 45,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
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
      body: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 0) {
            Navigator.pop(context);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: isDarkmode ? AppColor.secondary : AppColor.white,
          width: dw(context),
          height: dh(context),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(50, 0),
                  end: const Offset(-50, 0),
                ).animate(slideController),
                child: Transform.rotate(
                  angle: -30 * 3.14159265359 / 180,
                  child: Transform.scale(
                    scale: 2,
                    child: Container(
                      height: dh(context),
                      width: 20,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: dh(context) / 1.9,
                    width: dw(context) / 1.2,
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _customAnimatedContainer(
                                rotateController, isDarkmode, 0),
                            _customAnimatedContainer(
                                rotateController, isDarkmode, 1)
                          ],
                        ),
                        sh(40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _customButton(
                              bounceController
                                  .drive(Tween<double>(begin: 1.0, end: 1.1)),
                              () {
                                HapticFeedback.mediumImpact();
                                slideController.reverse();
                                rotateController.forward();
                                Future<void>.delayed(
                                  const Duration(milliseconds: 250),
                                  () {
                                    rotateController.reverse();
                                  },
                                );

                                localUser.setBool('darkmode', false);
                                setState(() {
                                  isDarkmode = false;
                                });
                                bounceController.forward(from: 0.0);
                              },
                              'Lightmode',
                            ),
                            _customButton(
                              zoomController
                                  .drive(Tween<double>(begin: 1.0, end: 1.1)),
                              () {
                                HapticFeedback.mediumImpact();
                                slideController.forward();
                                rotateController.forward();
                                Future<void>.delayed(
                                    const Duration(milliseconds: 400), () {
                                  rotateController.reverse();
                                });
                                localUser.setBool('darkmode', true);
                                setState(() {
                                  isDarkmode = true;
                                });
                                zoomController.forward(from: 0.0);
                              },
                              'Darkmode',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
