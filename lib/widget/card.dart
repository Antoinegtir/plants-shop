import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/models/plants.dart';
import 'package:ui_challenge/theme/theme.dart';
import 'package:ui_challenge/widget/plant.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key, required this.plant});
  final PlantModel plant;

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  bool isLiked = false;

  void like() {
    HapticFeedback.heavyImpact();
    setState(() {
      isLiked = true;
    });
    Future<void>.delayed(const Duration(milliseconds: 2200)).then((void value) {
      setState(() {
        isLiked = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    Color rcolor =
        !localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    PlantModel plant = widget.plant;
    return GestureDetector(
      onDoubleTap: like,
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<Widget>(
            builder: (BuildContext context) => PlantPage(plant: plant),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 294,
              color:
                  !localUser.getBool('darkmode')! ? Colors.white : Colors.black,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  sh(10),
                  Hero(
                    tag: plant.imageUrl ?? '',
                    child: CachedNetworkImage(
                      imageUrl: plant.imageUrl!,
                      height: 175,
                    ),
                  ),
                  sh(10),
                  Text(
                    plant.title ?? '',
                    style: TextStyle(
                      color: rcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    plant.description ?? '',
                    style: TextStyle(
                      color: rcolor,
                      fontWeight: FontWeight.w200,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  sh(20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "${plant.price ?? '9.99'}\$",
                          style: TextStyle(
                            color: rcolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        GestureDetector(
                          onTap: like,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 30,
                              width: 30,
                              color: rcolor,
                              child: Icon(
                                isLiked == true
                                    ? Iconsax.heart5
                                    : Iconsax.heart_add,
                                color: color,
                                size: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLiked)
            LottieBuilder.asset(
              'assets/animation/like.json',
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }
}
