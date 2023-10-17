// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/main.dart';
import 'package:ui_challenge/models/user.dart';
import 'package:ui_challenge/repositorys/upload.repository.dart';
import 'package:ui_challenge/services/profile.service.dart';
import 'package:ui_challenge/theme/theme.dart';
import 'package:ui_challenge/utility/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _bio;
  File? _image;
  void uploadImage() {
    openImagePicker(context, (File file) {
      setState(() {
        _image = file;
      });
    });
  }

  openImagePicker(BuildContext context, Function(File) onImageSelected) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(l(context).selectMethod),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                getImage(context, ImageSource.gallery, onImageSelected);
                setState(() {});
              },
              child: Text(l(context).pickImage),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                getImage(context, ImageSource.camera, onImageSelected);
              },
              child: Text(l(context).tookPicture),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  _image = null;
                });

                Navigator.pop(context);
              },
              child: Text(
                l(context).delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(l(context).cancel),
          ),
        );
      },
    );
  }

  Future<void> getImage(
    BuildContext context,
    ImageSource source,
    Function(File) onImageSelected,
  ) async {
    final XFile? file = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (file == null) {
      Navigator.pop(context);
      return;
    }

    CroppedFile? croppedFile = await Utility.cropImage(file.path);

    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
      });
      onImageSelected(_image!);
    }

    Navigator.pop(context);
  }

  Widget button(
    BuildContext context,
    String text,
    IconData icon,
    Function()? action,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
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
        onPressed: action,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 20,
              color: AppColor.primary,
            ),
            sw(10),
            Text(
              text,
              style: const TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.w300,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _bio = TextEditingController();
    _bio.text = localUser.getString('bio') ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    Color rcolor =
        !localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
    ProfileService state = Provider.of<ProfileService>(context, listen: false);
    UploadRepository upload =
        Provider.of<UploadRepository>(context, listen: false);
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        centerTitle: true,
        title: FadeInRight(
          child: Text(
            l(context).profile,
            style: TextStyle(color: rcolor),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              if (kAuth.currentUser == null) {
                return;
              }
              print(kAuth.currentUser);
              String? profileUrl;
              if (_image != null) {
                profileUrl = await upload.uploadProfileImage(
                    localUser.getString('user_id')!, _image!);
              }
              UserModel model = UserModel(
                userId: localUser.getString('user_id'),
                name: localUser.getString('name'),
                plantsId: localUser.getStringList('plants'),
                profilePic:
                    profileUrl ?? localUser.getString('profile_pic') ?? kP,
                bio: _bio.text,
              );
              state.updateProfile(model);
              Utility.storeUserDataLocally(model);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 20,
                width: 40,
                child: Text(
                  l(context).save,
                  style: TextStyle(color: rcolor),
                ),
              ),
            ),
          ),
        ],
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
      body: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 0) {
            Navigator.pop(context);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            sw(dw(context)),
            sh(50),
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                uploadImage();
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      if (_image != null)
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: (FileImage(_image!)),
                        )
                      else
                        CachedNetworkImage(
                          height: 150,
                          width: 150,
                          imageUrl: localUser.getString('profile_pic') ?? kP,
                          fit: BoxFit.cover,
                        ),
                      Container(
                        height: 150,
                        width: 150,
                        color: const Color.fromARGB(168, 0, 0, 0),
                      ),
                      Icon(
                        Iconsax.camera,
                        color: rcolor,
                        size: 40,
                      )
                    ],
                  )),
            ),
            sh(10),
            Text(
              localUser.getString('name')!,
              style: TextStyle(color: rcolor, fontSize: 30),
            ),
            sh(15),
            Container(
              width: dw(context) / 1.2,
              color: color,
              child: CupertinoTextField(
                cursorColor: AppColor.primary,
                style: TextStyle(color: rcolor),
                controller: _bio,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColor.primary),
                    borderRadius: BorderRadius.circular(20)),
                keyboardType: TextInputType.text,
                placeholder: '${l(context).bio}..',
                placeholderStyle: TextStyle(color: rcolor),
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                maxLength: 100,
                padding: const EdgeInsets.all(16.0),
                onChanged: (void text) {
                  setState(() {});
                },
              ),
            ),
            sh(30),
            button(context, l(context).logout, Iconsax.logout, () {
              localUser.clear();
              kAuth.signOut();
              kGoogle.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute<Widget>(
                  builder: (BuildContext context) => const PlantHome(),
                ),
                <Route>(Route route) => false,
              );
            }),
            sh(20),
            button(context, l(context).delete, Iconsax.profile_delete, () {
              localUser.clear();
              kAuth.signOut();
              kGoogle.signOut();
              state.deleteProfile(localUser.getString('user_id')!);
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute<Widget>(
                  builder: (BuildContext context) => const PlantHome(),
                ),
                <Route>(Route route) => false,
              );
            })
          ],
        ),
      ),
    );
  }
}
