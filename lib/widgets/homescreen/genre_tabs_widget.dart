import 'package:flutter/material.dart';
import 'package:tmdb/bloc/homescreen_bloc/get_movies_by_genre_bloc.dart';
import 'package:tmdb/model/genre.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/widgets/homescreen/genre_movies_widget.dart';

class GenreTabs extends StatefulWidget {

  final List<Genre> genres;

  const GenreTabs({Key? key, required this.genres}) : super(key: key);

  @override
  _GenreTabsState createState() => _GenreTabsState(genres);
}

class _GenreTabsState extends State<GenreTabs> with SingleTickerProviderStateMixin {

  final List<Genre> genres;
  late final TabController _tabController;

  _GenreTabsState(this.genres);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: genres.length);
    _tabController.addListener(() {
      if(_tabController.indexIsChanging){
        moviesByGenreBloc.drainStream();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.0,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              backgroundColor: MyColors.mainColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: MyColors.secondColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                unselectedLabelColor: MyColors.titleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((Genre genre) {
                  return Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                    child: Text(
                        genre.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  );
                }).toList(growable: true),
              ),
            ),
          ),
          backgroundColor: MyColors.mainColor,
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: genres.map((Genre genre) {
              return GenreMovies(genreId: genre.id);
            }).toList(growable: true),
          ),
        ),
      ),
    );
  }
}
