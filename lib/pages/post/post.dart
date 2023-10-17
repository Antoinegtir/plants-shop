// ignore_for_file: always_specify_types, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/models/plants.dart';
import 'package:ui_challenge/repositorys/upload.repository.dart';
import 'package:ui_challenge/services/plant.service.dart';
import 'package:ui_challenge/theme/theme.dart';
import 'package:ui_challenge/utility/utils.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _height = TextEditingController();
  final TextEditingController _pot = TextEditingController();
  final TextEditingController _temperature = TextEditingController();
  File? _plants;

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
        _plants = File(croppedFile.path);
      });
      onImageSelected(_plants!);
    }
  }

  Widget customTextInput(
    Color color,
    Color rcolor,
    String description,
    TextEditingController text,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: dw(context) / 1.2,
        color: color,
        child: CupertinoTextField(
          style: TextStyle(color: rcolor),
          cursorColor: AppColor.primary,
          controller: text,
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: AppColor.primary),
              borderRadius: BorderRadius.circular(20)),
          keyboardType: TextInputType.text,
          placeholder: description,
          placeholderStyle: TextStyle(color: rcolor),
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLength: 100,
          padding: const EdgeInsets.all(16.0),
          onChanged: (void text) {
            setState(() {});
          },
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
    PlantService state = Provider.of<PlantService>(context, listen: false);
    UploadRepository uploadRepository =
        Provider.of<UploadRepository>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: FadeInDown(
          child: Text(
            l(context).post,
            style: TextStyle(color: rcolor),
          ),
        ),
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
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_down_sharp,
            size: 40,
            color: rcolor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            sw(dw(context)),
            sh(120),
            if (_plants != null)
              Image.file(_plants!)
            else
              GestureDetector(
                onTap: () {
                  getImage(context, ImageSource.gallery, (File file) {
                    setState(() {
                      _plants = file;
                    });
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const <double>[15, 4],
                    strokeCap: StrokeCap.round,
                    color: AppColor.primary,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        width: 200,
                        height: 305,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              size: 50,
                              CupertinoIcons.photo,
                              color: AppColor.primary,
                            ),
                            sh(20),
                            Text(
                              l(context).upload,
                              style: TextStyle(color: rcolor, fontSize: 21),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            sh(30),
            customTextInput(color, rcolor, l(context).title, _title),
            customTextInput(
                color, rcolor, l(context).description, _description),
            customTextInput(color, rcolor, l(context).price, _price),
            customTextInput(color, rcolor, l(context).height, _height),
            customTextInput(
                color, rcolor, l(context).temperature, _temperature),
            customTextInput(color, rcolor, l(context).pot, _pot),
            sh(dh(context) / 5)
          ],
        ),
      ),
      backgroundColor: color,
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left: 28),
        width: dw(context),
        child: GestureDetector(
          onTap: () {
            if (_plants == null ||
                _pot.text.isEmpty ||
                _price.text.isEmpty ||
                _temperature.text.isEmpty ||
                _description.text.isEmpty ||
                _height.text.isEmpty ||
                _title.text.isEmpty) {
              return;
            }
            DocumentReference plantId = kFirestore.collection('posts').doc();

            uploadRepository.uploadPlants(_plants!).then((String? value) {
              PlantModel model = PlantModel(
                pot: _pot.text,
                price: _price.text,
                temperature: _temperature.text,
                description: _description.text,
                title: _title.text,
                height: _height.text,
                plantId: plantId.id,
                imageUrl: value!,
              );
              state.salePlant(model);
            });
            Navigator.pop(context);
          },
          child: Hero(
            tag: 'back',
            child: Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColor.primary),
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
