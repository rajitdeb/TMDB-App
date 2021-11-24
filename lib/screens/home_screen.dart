import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/screens/detail_screen.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/widgets/genre_widget.dart';
import 'package:tmdb/widgets/now_playing_widget.dart';
import 'package:tmdb/widgets/person_widget.dart';
import 'package:tmdb/widgets/search_widget.dart';
import 'package:tmdb/widgets/top_rated_movies_in_india_widget.dart';
import 'package:tmdb/widgets/top_rated_movies_in_us.dart';

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
        title: const Text("TMDB"),
        actions: [
          IconButton(
              onPressed: () {
                final response = showSearch(context: context, delegate: SearchMovies());
                response.then((value) => {
                  if(value != null){
                    Get.to(() => const MovieDetailsScreen(), arguments: value)
                  }
                });
              },
              icon: const Icon(EvaIcons.searchOutline, color: Colors.white)
          )
        ],
      ),
      body: ListView(
        children: const [
          NowPlaying(),
          GenreWidget(),
          TopRatedMoviesInIndia(),
          TopRatedMoviesInUS(),
          PersonList(),
        ],
      ),
    );
  }
}
