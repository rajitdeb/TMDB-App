import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieVideoPlayer extends StatefulWidget {

  const MovieVideoPlayer({Key? key}) : super(key: key);

  @override
  _MovieVideoPlayerState createState() => _MovieVideoPlayerState();
}

class _MovieVideoPlayerState extends State<MovieVideoPlayer> {

  final String videoId = Get.arguments;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        hideControls: false,
        autoPlay: true,
        forceHD: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.toggleFullScreenMode();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
          ),
        ),
      ),
    );
  }

}
