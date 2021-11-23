import 'package:tmdb/model/review.dart';

class MovieReviewResponse {

  final List<MovieReview>? reviews;
  final String? error;

  MovieReviewResponse.fromJson(Map<String, dynamic> json)
    : reviews = (json["results"] as List).map((e) => MovieReview.fromJson(e)).toList(),
      error = null;

  MovieReviewResponse.withError(String errorValue)
    : reviews = null,
      error = errorValue;

}