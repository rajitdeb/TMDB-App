import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tmdb/bloc/homescreen_bloc/get_now_playing_movies_bloc.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final _pageController = PageController(viewportFraction: 1, keepPage: true);

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
      },
    );
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
              child: Lottie.asset("assets/gradient_circular_loader.json"),
            ),
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
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
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
      final pages = List.generate(
        movies.length,
        (index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade300,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 220.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "${Constants.baseImageUrl}${movies[index].backPoster}",
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 35.0,
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
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );

      return SizedBox(
        height: 220.0,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 220.0,
                    child: PageView.builder(
                      controller: _pageController,
                      // itemCount: pages.length,
                      itemBuilder: (_, index) {
                        return pages[index % pages.length];
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 15.0,
              child: SmoothPageIndicator(
                controller: _pageController,
                count:
                    (movies.length > 8) ? movies.take(8).length : movies.length,
                effect: const WormEffect(
                  dotHeight: 10.0,
                  dotWidth: 10.0,
                  activeDotColor: MyColors.secondColor,
                ),
              ),
            ),
          ],
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

  void _launchURL(String url) async {
    String completeUrl = "${Constants.youtubeBaseUrl}$url";
    if (!await launchUrl(Uri.parse(completeUrl))) {
      throw 'Could not launch $completeUrl';
    }
  }
}
