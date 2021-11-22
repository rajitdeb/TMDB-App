import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:tmdb/bloc/get_movie_details_bloc.dart';
import 'package:tmdb/bloc/get_movie_videos_bloc.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/model/movie_video.dart';
import 'package:tmdb/model/movie_video_response.dart';
import 'package:tmdb/screens/movie_video_player_screen.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';
import 'package:tmdb/widgets/casts_widget.dart';
import 'package:tmdb/widgets/more_video_of_current_movie.dart';
import 'package:tmdb/widgets/movie_info.dart';
import 'package:tmdb/widgets/similar_movies_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsScreen extends StatefulWidget {

  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState(movie);
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {

  final Movie movie;

  _MovieDetailsScreenState(this.movie);

  @override
  void initState() {
    super.initState();
    getMovieDetailsBloc.getMovieDetails(movie.id);
    movieVideosBloc.getMovieVideos(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideosBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.mainColor,
      body: Builder(builder: (BuildContext context) {
        return SliverFab(
          floatingPosition: const FloatingPosition(right: 20.0),
          floatingWidget: StreamBuilder<MovieVideoResponse>(
            stream: movieVideosBloc.subject.stream,
            builder: (BuildContext context, AsyncSnapshot<MovieVideoResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.error != null && snapshot.data!.error!.isEmpty) {
                  return _buildErrorWidget(snapshot.data!.error);
                }
                return _buildMovieVideosWidget(snapshot.data);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else {
                return _buildLoadingWidget();
              }
          },),
          expandedHeight: 200.0,
          slivers: [
            SliverAppBar(
              backgroundColor: MyColors.mainColor,
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                    movie.title.length > 40
                    ? movie.title.substring(0, 20) + "..."
                    : movie.title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold
                ),
                ),

                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: NetworkImage(
                            "${Constants.baseImageUrl}${movie.backPoster}",
                          ),
                            fit: BoxFit.cover
                        )
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5)
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0)
                          ]
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(0.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (movie.rating / 2).toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(
                            width: 5.0,
                          ),

                          RatingBar.builder(
                              itemSize: 14.0,
                              initialRating: (movie.rating / 2).toDouble(),
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
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Text(
                        "OVERVIEW",
                        style: TextStyle(
                          color: MyColors.titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0
                        )
                      ),
                    ),

                    SizedBox(height: 5.0),

                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        movie.overview,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          height: 1.5
                        ),
                      ),
                    ),

                    SizedBox(height: 10.0),

                    MovieInfoWidget(id: movie.id,),

                    CastsWidget(id: movie.id,),

                    MoreVideosOfCurrentMovie(id: movie.id),

                    SimilarMoviesWidget(id: movie.id),

                  ]
                ),
              ),
            )
          ],
        );
      },),
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

  Widget _buildMovieVideosWidget(MovieVideoResponse? data) {
    List<MovieVideo>? movieVideos = data?.movieVideos;
    if (movieVideos == null || movieVideos.isEmpty) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 250.0,
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
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieVideoPlayer(
                controller: YoutubePlayerController(
                  initialVideoId: movieVideos[0].key,
                  flags: YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                  ),
                ),
              ),
            ),
          );
        },
        backgroundColor: MyColors.secondColor,
        child: const Icon(Icons.play_arrow, color: Colors.white,),
      );
    }
  }

}
