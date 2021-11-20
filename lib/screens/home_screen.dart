import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/widgets/genre_widget.dart';
import 'package:tmdb/widgets/now_playing_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      appBar: AppBar(
        backgroundColor: MyColors.mainColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(EvaIcons.menu2Outline, color: Colors.white),
          onPressed: () {  },
        ),
        title: const Text("TMDB"),
        actions: const [
          IconButton(
              onPressed: null,
              icon: Icon(EvaIcons.searchOutline, color: Colors.white)
          )
        ],
      ),
      body: ListView(
        children: [
          NowPlaying(),
          GenreWidget()
        ],
      ),
    );
  }
}
