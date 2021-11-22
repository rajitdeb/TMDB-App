import 'package:tmdb/model/movie_video.dart';

class MovieVideoResponse {

  final List<MovieVideo>? movieVideos;
  final String? error;

  MovieVideoResponse(this.movieVideos, this.error);

  MovieVideoResponse.fromJson(Map<String, dynamic> json)
    : movieVideos = (json["results"] as List).map((e) => MovieVideo.fromJson(e)).toList(),
      error = null;

  MovieVideoResponse.withError(String errorValue)
    : movieVideos = null,
      error = errorValue;
}