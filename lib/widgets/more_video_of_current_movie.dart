import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/bloc/get_movie_videos_bloc.dart';
import 'package:tmdb/model/movie_video.dart';
import 'package:tmdb/model/movie_video_response.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreVideosOfCurrentMovie extends StatefulWidget {
  final int id;

  const MoreVideosOfCurrentMovie({Key? key, required this.id})
      : super(key: key);

  @override
  _MoreVideosOfCurrentMovieState createState() =>
      _MoreVideosOfCurrentMovieState(id);
}

class _MoreVideosOfCurrentMovieState extends State<MoreVideosOfCurrentMovie> {
  final int id;

  _MoreVideosOfCurrentMovieState(this.id);

  @override
  void initState() {
    super.initState();
    movieVideosBloc.getMovieVideos(id);
  }

  @override
  void dispose() {
    movieVideosBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "VIDEOS FROM THIS MOVIE",
            style: TextStyle(
                color: MyColors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        StreamBuilder<MovieVideoResponse>(
          stream: movieVideosBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieVideoResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error != null &&
                  snapshot.data!.error!.isEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildMoreMovieVideosWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else {
              return _buildLoadingWidget();
            }
          },
        )
      ],
    );
  }

  Widget _buildErrorWidget(String? error) {
    return SizedBox(
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

  Widget _buildMoreMovieVideosWidget(MovieVideoResponse? data) {
    List<MovieVideo>? videos = data?.movieVideos;

    return videos == null || videos.isEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            padding: const EdgeInsets.only(left: 10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Text(
                        "No videos found for this movie.",
                        style: TextStyle(color: MyColors.titleColor),
                      )
                    ],
                  )
                ],
              ),
            ))
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            padding: const EdgeInsets.only(left: 10.0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 15.0),
                    child: GestureDetector(
                        onTap: () {
                          print("Item Cliked! Name: ${videos[index].name}");
                          // Get.to(MovieVideoPlayer(), arguments: videos[index].key);
                          _launchURL(videos[index].key);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: videos[index].id,
                              child: Container(
                                width: 250.0,
                                height: 150.0,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(2.0),
                                    ),
                                    shape: BoxShape.rectangle,
                                    color: Colors.black),
                                child: const Center(
                                  child: Icon(
                                    EvaIcons.playCircle,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              width: 250.0,
                              height: 20.0,
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                videos[index].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    height: 1.4,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0),
                              ),
                            ),
                          ],
                        )),
                  );
                }),
          );
  }

  void _launchURL(String _url) async {
    String completeUrl = "${Constants.youtubeBaseUrl}$_url";
    if (!await launch(completeUrl)) throw 'Could not launch $completeUrl';
  }
}
