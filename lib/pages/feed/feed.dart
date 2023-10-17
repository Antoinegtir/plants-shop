// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:ui_challenge/constant/const.dart';
import 'package:ui_challenge/services/plant.service.dart';
import 'package:ui_challenge/theme/theme.dart';
import 'package:ui_challenge/widget/card.dart';

class FeedPlantPage extends StatefulWidget {
  const FeedPlantPage({super.key});

  @override
  State<FeedPlantPage> createState() => _FeedPlantPageState();
}

class _FeedPlantPageState extends State<FeedPlantPage> {
  Color rcolor =
      !localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;
  Color color =
      localUser.getBool('darkmode')! ? AppColor.secondary : AppColor.white;

  late Future<List<DocumentSnapshot<Map<String, dynamic>>>> plants;
  @override
  void initState() {
    PlantService state = Provider.of<PlantService>(context, listen: false);
    plants = state.fetchPlants();
    super.initState();
  }

  bool _isRefreshing = false;
  Future<void> _refreshPosts() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future<void>.delayed(const Duration(seconds: 2));
    final PlantService state =
        Provider.of<PlantService>(context, listen: false);
    setState(() {
      _isRefreshing = false;
      plants = state.fetchPlants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPosts,
      backgroundColor: color,
      child: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: plants,
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot<Map<String, dynamic>>>>
                snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              _isRefreshing) {
            return Container();
          }
          final List<DocumentSnapshot<Map<String, dynamic>>>? plants =
              snapshot.data;
          return StaggeredGridView.countBuilder(
            staggeredTileBuilder: (int index) =>
                const StaggeredTile.count(1, 1.8),
            crossAxisCount: 2,
            padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
            itemCount: plants?.length ?? 0,
            mainAxisSpacing: 10,
            crossAxisSpacing: 25,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot<Map<String, dynamic>> plantsDoc =
                  plants![index];
              final Map<String, dynamic>? plant = plantsDoc.data();
              PlantService state =
                  Provider.of<PlantService>(context, listen: false);
              if (index % 2 == 0) {
                if (index == 0) {
                  return FadeInUp(
                    duration: const Duration(seconds: 1),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Transform.translate(
                          offset: const Offset(0.0, 100.0),
                          child: CardPage(
                            key: widget.key,
                            plant: state.fetchPlant(plant!),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0.0, -100.0),
                          child: Text(
                            '${l(context).find}\n${plants.length} ${l(context).result}',
                            style: TextStyle(
                                color: rcolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: Transform.translate(
                    offset: const Offset(0.0, 100.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CardPage(
                        key: widget.key,
                        plant: state.fetchPlant(plant!),
                      ),
                    ),
                  ),
                );
              } else {
                return FadeInDown(
                  duration: const Duration(seconds: 1),
                  child: CardPage(
                    key: widget.key,
                    plant: state.fetchPlant(plant!),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
