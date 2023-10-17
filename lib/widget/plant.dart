import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/models/plants.dart';
import 'package:ui_challenge/utility/utils.dart';

import '../theme/theme.dart';

class PlantPage extends StatelessWidget {
  const PlantPage({super.key, required this.plant});
  final PlantModel plant;

  @override
  Widget build(BuildContext context) {
    Color color =
        localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    Color rcolor =
        !localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FadeInRight(
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(
              Iconsax.shopping_cart,
              size: 27,
              color: rcolor,
            ),
          ),
        ],
      ),
      backgroundColor: color,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: plant.imageUrl!,
            child: CachedNetworkImage(
              height: 320,
              width: dw(context),
              imageUrl: plant.imageUrl!,
            ),
          ),
          sh(20),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              plant.title!,
              style: TextStyle(
                color: rcolor,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          sh(20),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Text(
              plant.description!,
              style: TextStyle(
                color: rcolor,
                fontWeight: FontWeight.w200,
                fontSize: 14,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      bottomNavigationBar: FadeInUp(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: Container(
            color: AppColor.primary,
            height: dh(context) / 3.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                sh(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    sw(10),
                    Utility.icon(
                      l(context).height,
                      Icons.height,
                      plant.height ?? '30cm - 40cm',
                    ),
                    Utility.icon(
                      l(context).temperature,
                      CupertinoIcons.thermometer,
                      plant.temperature ?? '20°C to 25°C',
                    ),
                    Utility.icon(
                      l(context).pot,
                      CupertinoIcons.tree,
                      plant.pot ?? 'Ciramic Pot',
                    ),
                    sw(10),
                  ],
                ),
                sh(20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                l(context).total,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${plant.price ?? '9.99'}\$",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              showDialog(
                                context: context,
                                builder: (_) => CupertinoAlertDialog(
                                  title: Text(l(context).thanks),
                                  content: Text(l(context).purchase),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              color: AppColor.third,
                              width: 120,
                              height: 60,
                              alignment: Alignment.center,
                              child: Text(
                                l(context).pay,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
      ),
    );
  }
}
