import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ui_challenge/pages/onboard/widget/dotindicator.dart';
import 'package:ui_challenge/pages/onboard/widget/nextbutton.dart';
import 'package:ui_challenge/pages/onboard/widget/plantcard.dart';
import 'package:ui_challenge/theme/theme.dart';
import '../../constant/const.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> onboardList(BuildContext context) =>
      <Map<String, dynamic>>[
        <String, dynamic>{
          'image': '1.json',
          'text': l(context).firstOnboard,
        },
        <String, dynamic>{
          'image': '2.json',
          'text': l(context).secondOnboard,
        },
        <String, dynamic>{
          'image': '3.json',
          'text': l(context).thirdOnboard,
        },
      ];

  int current = 0;
  final CarouselController _carouselController = CarouselController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _carouselController.jumpToPage(2);
            },
            child: Text(
              l(context).skip,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationButton(
        current: current,
        controller: _controller,
        carouselController: _carouselController,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                scrollPhysics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                aspectRatio: dw(context) / dh(context),
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  setState(() {
                    current = index;
                  });
                },
              ),
              items: onboardList(context).map((Map<String, dynamic> model) {
                return PlantCard(
                  key: widget.key,
                  model: model,
                  current: current,
                );
              }).toList()),
          DotIndactor(
            key: widget.key,
            current: current,
          ),
        ],
      ),
    );
  }
}
