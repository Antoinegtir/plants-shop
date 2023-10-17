import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/pages/feed/feed.dart';
import 'package:ui_challenge/pages/post/post.dart';
import 'package:ui_challenge/pages/profile/profile.dart';
import 'package:ui_challenge/theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  FocusNode focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    Color color =
        localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    Color rcolor =
        !localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: color,
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                CupertinoPageRoute<Widget>(
                  builder: (BuildContext context) => const ProfilePage(),
                ),
              ).then((void value) {
                Future<void>.delayed(const Duration(seconds: 3))
                    .then((void value) {
                  setState(() {});
                });
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 30, top: 8, bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: localUser.getString('profile_pic') ?? kP,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 100,
              color: Colors.black.withOpacity(0),
              width: MediaQuery.of(context).size.width / 1,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          l(context).search,
          style: TextStyle(color: rcolor),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            CupertinoPageRoute<Widget>(
              fullscreenDialog: true,
              builder: (BuildContext context) => const PostPage(),
            ),
          );
        },
        child: Hero(
          tag: 'back',
          child: Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColor.primary),
            child: const Icon(
              Iconsax.add_circle,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              leading: const SizedBox.shrink(),
              expandedHeight: 100.0,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                centerTitle: false,
                expandedTitleScale: 1.1,
                background: Column(
                  children: <Widget>[
                    sh(130),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: dw(context) / 1.4,
                          height: 50,
                          decoration: BoxDecoration(
                            color: !localUser.getBool('darkmode')!
                                ? Colors.white
                                : Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: CupertinoTextField(
                            cursorColor: AppColor.primary,
                            prefix: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Icon(
                                Iconsax.search_normal,
                                color: rcolor,
                              ),
                            ),
                            suffix: GestureDetector(
                              onTap: () {
                                focus.unfocus();
                                _textEditingController.clear();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.close,
                                  color: rcolor,
                                ),
                              ),
                            ),
                            keyboardAppearance: localUser.getBool('darkmode')!
                                ? Brightness.dark
                                : Brightness.light,
                            focusNode: focus,
                            controller: _textEditingController,
                            placeholder: l(context).plants,
                            placeholderStyle: TextStyle(color: rcolor),
                            style: TextStyle(color: rcolor),
                            decoration: const BoxDecoration(),
                            maxLines: 1,
                            onChanged: (String value) {
                              setState(() {});
                            },
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLength: 50,
                            padding: const EdgeInsets.all(16.0),
                          ),
                        ),
                        sw(10),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) => ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                                child: Container(
                                  color: color,
                                  height: dh(context) / 1.8,
                                  width: dw(context),
                                  child: Column(
                                    children: <Widget>[
                                      sh(15),
                                      Container(
                                        width: 70,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      sh(20),
                                      Text(
                                        l(context).filterPlants,
                                        style: TextStyle(
                                            color: rcolor, fontSize: 25),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: !localUser.getBool('darkmode')!
                                  ? Colors.white
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.display_settings_rounded,
                              color: rcolor,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: FeedPlantPage(key: widget.key),
      ),
    );
  }
}
