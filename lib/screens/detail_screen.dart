import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmdb/bloc/get_movie_videos_bloc.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/model/movie_video.dart';
import 'package:tmdb/model/movie_video_response.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';
import 'package:tmdb/widgets/casts_widget.dart';
import 'package:tmdb/widgets/crew_widget.dart';
import 'package:tmdb/widgets/more_video_of_current_movie.dart';
import 'package:tmdb/widgets/movie_info.dart';
import 'package:tmdb/widgets/movie_reviews_widget.dart';
import 'package:tmdb/widgets/similar_movies_widget.dart';

class MovieDetailsScreen extends StatefulWidget {

  const MovieDetailsScreen({Key? key}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final Movie movie = Get.arguments as Movie;

  @override
  void initState() {
    super.initState();
    print("Fetching title from Args: ${movie.id}");
    movieVideosBloc.getMovieVideos(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideosBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    final Movie movie = Get.arguments as Movie;

    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Builder(
        builder: (BuildContext context) {
          return StreamBuilder(
              stream: movieVideosBloc.subject.stream,
              builder: (context, AsyncSnapshot<MovieVideoResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.error != null &&
                      snapshot.data!.error!.isEmpty) {
                    return _buildErrorWidget(snapshot.data!.error);
                  }
                  return _buildMovieVideosWidget(movie);
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error.toString());
                } else {
                  return _buildLoadingWidget();
                }
              });
        },
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
          children: const [
            Text(
              "An Error Occurred. Please try again later",
              style: TextStyle(
                color: MyColors.titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            )
          ],
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

  Widget _buildMovieVideosWidget(Movie movie) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: MyColors.mainColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(movie.title.length > 20
                  ? movie.title.substring(0, 20) + "..."
                  : movie.title),
              background: movie.backPoster == null
                  ? Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.black),
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48.0,
                        color: Colors.white,
                      ),
                    )
                  : Image.network(
                      "${Constants.baseImageUrl}${movie.backPoster}",
                      fit: BoxFit.cover,
                    ),
            ),
          )
        ];
      },
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${(movie.rating / 2).toDouble()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  RatingBar.builder(
                      itemSize: 14.0,
                      initialRating: (movie.rating / 2).toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => const Icon(EvaIcons.star,
                          color: MyColors.secondColor),
                      onRatingUpdate: (rating) {
                        print(rating);
                      })
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, top: 20.0),
              child: Text("OVERVIEW",
                  style: TextStyle(
                      color: MyColors.titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0)),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                movie.overview,
                style: const TextStyle(
                    color: Colors.white, fontSize: 12.0, height: 1.5),
              ),
            ),
            const SizedBox(height: 10.0),
            MovieInfoWidget(
              id: movie.id,
            ),
            CastsWidget(
              id: movie.id,
            ),
            CrewWidget(id: movie.id),
            MoreVideosOfCurrentMovie(id: movie.id),
            MovieReviewsWidget(id: movie.id),
            SimilarMoviesWidget(id: movie.id),
          ],
        ),
      ),
    );
  }
}
