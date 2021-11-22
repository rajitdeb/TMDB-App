import 'package:tmdb/model/movie_detail.dart';

class MovieDetailResponse {
  final MovieDetail? movieDetails;
  final String? error;

  MovieDetailResponse(this.movieDetails, this.error);

  MovieDetailResponse.fromJson(Map<String, dynamic> json)
      : movieDetails = MovieDetail.fromJson(json),
        error = null;

  MovieDetailResponse.withError(String errorValue)
      : movieDetails = null,
        error = errorValue;

}