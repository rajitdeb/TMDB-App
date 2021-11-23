import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:tmdb/bloc/get_movies_by_genre_bloc.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/screens/detail_screen.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;

  const GenreMovies({Key? key, required this.genreId}) : super(key: key);

  @override
  _GenreMoviesState createState() => _GenreMoviesState(genreId);
}

class _GenreMoviesState extends State<GenreMovies> {
  final int genreId;

  _GenreMoviesState(this.genreId);

  @override
  void initState() {
    super.initState();
    moviesByGenreBloc.getMoviesByGenres(genreId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null && snapshot.data!.error!.isEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildGenreMoviesWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildErrorWidget(String? error) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Error occurred: $error")],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGenreMoviesWidget(MovieResponse? data) {
    List<Movie>? movies = data?.movies.cast<Movie>();
    if (movies == null || movies.isEmpty) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text(
                  "No movies to display",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
          height: 100.0,
          padding: const EdgeInsets.only(left: 10.0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      right: 10.0
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const MovieDetailsScreen(), arguments: movies[index]);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        movies[index].poster == null
                            ? Container(
                          width: 120.0,
                          height: 150.0,
                          decoration: const BoxDecoration(
                              color: MyColors.secondColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(2.0)),
                              shape: BoxShape.rectangle
                          ),
                          child: Column(
                            children: const [
                              Icon(EvaIcons.filmOutline, color: Colors.white,
                                size: 50.0,)
                            ],
                          ),
                        )
                            : Container(
                          width: 120.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(2.0)
                            ),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: NetworkImage("${Constants
                                    .baseImageUrl_w200}${movies[index].poster}"),
                                fit: BoxFit.cover
                            ),
                          ),
                        ),

                        SizedBox(
                            height: 10.0
                        ),

                        Container(
                          width: 100.0,
                          child: Text(
                            movies[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                height: 1.4,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0
                            ),
                          ),
                        ),

                        const SizedBox(height: 5.0),

                        Row(
                          children: [
                            RatingBar.builder(
                                itemSize: 14.0,
                                initialRating: movies[index].rating / 2,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 2.0),
                                itemBuilder: (context, _) =>
                                const Icon(
                                    EvaIcons.star,
                                    color: MyColors.secondColor
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                }
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
          )
      );
    }
  }
}
