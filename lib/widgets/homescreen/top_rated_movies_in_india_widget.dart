import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tmdb/bloc/homescreen_bloc/top_rated_movies_bloc.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/screens/detail_screen.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';

class TopRatedMoviesInIndia extends StatefulWidget {
  const TopRatedMoviesInIndia({Key? key}) : super(key: key);

  @override
  _TopRatedMoviesInIndiaState createState() => _TopRatedMoviesInIndiaState();
}

class _TopRatedMoviesInIndiaState extends State<TopRatedMoviesInIndia> {
  @override
  void initState() {
    super.initState();
    topRatedMoviesBloc.getTopRatedMoviesInIndia();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.only(left: 10.0, top: 20.0),
              child: Text(
                "TOP RATED MOVIES IN INDIA",
                style: TextStyle(
                    color: MyColors.titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0),
              )),
          const SizedBox(
            height: 10.0,
          ),
          StreamBuilder<MovieResponse>(
            stream: topRatedMoviesBloc.subjectInIndia.stream,
            builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.error != null &&
                    snapshot.data!.error!.isEmpty) {
                  return _buildErrorWidget(snapshot.data!.error);
                }
                print("MovieResponse is not null");
                return _buildTopRatedMoviesWidget(snapshot.data);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else {
                return _buildLoadingWidget();
              }
            },
          )
        ],
      ),
    );
  }


    Widget _buildErrorWidget(String? error) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Error occurred: $error")],
          ),
        ),
      );
    }

  Widget _buildLoadingWidget() {
    return SizedBox(
      height: 270.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 70.0,
                child: Lottie.asset("assets/gradient_circular_loader.json")
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopRatedMoviesWidget(MovieResponse? data) {
    List<Movie?>? movies = data?.movies;
    if(movies == null && movies!.isEmpty){
      print("MovieResponse is null or empty");
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text(
                  "No trending people to display",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
          height: 220.0,
          padding: const EdgeInsets.only(left: 10.0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(
                    //     builder: (BuildContext context) =>
                    //         MovieDetailsScreen()
                    // ));

                    Get.to(() => const MovieDetailsScreen(), arguments: movies[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        right: 10.0
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        movies[index]!.poster == null
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                    .baseImageUrl_w200}${movies[index]!.poster}"),
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
                            movies[index]!.title,
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
                                initialRating: movies[index]!.rating / 2,
                                minRating: 1,
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
