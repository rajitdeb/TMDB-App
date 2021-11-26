import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:tmdb/bloc/homescreen_bloc/get_now_playing_movies_bloc.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    nowPlayingMoviesBloc.getNowPlayingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: nowPlayingMoviesBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.error != null &&
                snapshot.data!.error!.isNotEmpty) {
              return _buildErrorWidget(snapshot.data!.error);
            }
            return _buildNowPlayingWidget(snapshot.data);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          } else {
            return _buildLoadingWidget();
          }
        });
  }

  Widget _buildLoadingWidget() {
    return SizedBox(
      height: 220.0,
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

  Widget _buildNowPlayingWidget(MovieResponse? data) {
    List<Movie>? movies = data?.movies.cast<Movie>();
    if (movies == null || movies.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text(
                  "No more movies to display",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 220.0,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          length: movies.take(5).length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5.0),
          indicatorColor: MyColors.titleColor,
          indicatorSelectorColor: MyColors.secondColor,
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.horizontal,
              itemCount: movies.take(5).length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 220.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "${Constants.baseImageUrl}${movies[index].backPoster}"))),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: const [
                              0.0,
                              0.9
                            ],
                                colors: [
                              MyColors.mainColor.withOpacity(1.0),
                              MyColors.mainColor.withOpacity(0.0)
                            ])),
                      ),

                      Positioned(
                        bottom: 30.0,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          width: 250.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movies[index].title.toString(),
                                style: const TextStyle(
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                );
              }),
        ),
      );
    }
  }

  Widget _buildErrorWidget(String? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Error occurred: $error")],
      ),
    );
  }

  void _launchURL(String _url) async {
    String completeUrl = "${Constants.youtubeBaseUrl}$_url";
    if (!await launch(completeUrl)) throw 'Could not launch $completeUrl';
  }
}
