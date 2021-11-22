import 'package:flutter/material.dart';
import 'package:tmdb/style/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieVideoPlayer extends StatefulWidget {

  final YoutubePlayerController controller;

  const MovieVideoPlayer({Key? key, required this.controller}) : super(key: key);

  @override
  _MovieVideoPlayerState createState() => _MovieVideoPlayerState(controller);
}

class _MovieVideoPlayerState extends State<MovieVideoPlayer> {

  final YoutubePlayerController controller;

  _MovieVideoPlayerState(this.controller);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.mainColor,
        child: Center(
          child: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
          ),
        ),
      ),
    );
  }
}
