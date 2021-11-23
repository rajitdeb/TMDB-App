import 'package:dio/dio.dart';
import 'package:tmdb/model/cast_response.dart';
import 'package:tmdb/model/crew.dart';
import 'package:tmdb/model/crew_response.dart';
import 'package:tmdb/model/genreresponse.dart';
import 'package:tmdb/model/movie_detail_response.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/model/movie_video_response.dart';
import 'package:tmdb/model/personresponse.dart';
import 'package:tmdb/model/review_response.dart';
import 'package:tmdb/utils/Constants.dart';

class MovieRepository {
  // http provider - just like Retrofit in Android
  final Dio _dio = Dio();

  // endpoints
  var getAllPopularMovies = "${Constants.baseUrl}/movie/popular";
  var getTopRatedRMovies = "${Constants.baseUrl}/discover/movie";
  var getMovieDetail = "${Constants.baseUrl}/movie/";
  var discoverMovie = "${Constants.baseUrl}/discover/movie";
  var getNowPlaying = "${Constants.baseUrl}/movie/now_playing";
  var getAllGenres = "${Constants.baseUrl}/genre/movie/list";
  var getAllTrendingPersonality = "${Constants.baseUrl}/trending/person/week";

  // functions

  Future<MovieDetailResponse> getMovieDetails(int movieId) async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "page": 1
    };

    try {
      Response response =
      await _dio.get("$getMovieDetail/$movieId", queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return MovieDetailResponse.withError(e.toString());
    }
  }

  Future<MovieResponse> getTopRatedMoviesInIndia() async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "certification_country": "IN",
      "certification": "U",
      "sort_by": "vote_average.desc",
      "include_adult": "false",
      "page": 1
    };

    try {
      Response response =
      await _dio.get(getTopRatedRMovies, queryParameters: params);
      // print(response.data.toString());
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return MovieResponse.withError(e.toString());
    }
  }

  Future<MovieResponse> getTopRatedMoviesInUs() async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "certification_country": "US",
      "certification": "PG-13",
      "sort_by": "vote_average.desc",
      "include_adult": "false",
      "page": 1
    };

    try {
      Response response =
      await _dio.get(getTopRatedRMovies, queryParameters: params);
      // print(response.data.toString());
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return MovieResponse.withError(e.toString());
    }
  }

  Future<MovieResponse> getPopularMovies() async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "page": 1
    };

    try {
      Response response =
          await _dio.get(getAllPopularMovies, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return MovieResponse.withError(e.toString());
    }
  }

  Future<MovieResponse> getNowPlayingMovies() async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "page": 1
    };

    try {
      Response response =
          await _dio.get(getNowPlaying, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return MovieResponse.withError(e.toString());
    }
  }

  // Future<MovieResponse> getAMovieDetail(int movieId) async {
  //
  //   var getAMovieDetailUrl = "$getMovieDetail/$movieId";
  //
  //   var params = {
  //     "api_key": Constants.apiKey,
  //     "language": "en-US"
  //   };
  //
  //   try {
  //
  //     Response response = await _dio.get(getAMovieDetailUrl, queryParameters: params);
  //     return MovieResponse.fromJson(response.data);
  //
  //   } catch (e) {
  //     print(e);
  //     return MovieResponse.withError(e.toString());
  //   }
  // }

  Future<GenreResponse> getGenres() async {
    var params = {"api_key": Constants.apiKey, "language": "en-US"};

    try {
      Response response = await _dio.get(getAllGenres, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return GenreResponse.withError(e.toString());
    }
  }

  Future<PersonResponse> getTrendingPeople() async {
    var params = {"api_key": Constants.apiKey};

    try {
      Response response =
          await _dio.get(getAllTrendingPersonality, queryParameters: params);
      return PersonResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return PersonResponse.withError(e.toString());
    }
  }

  Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "page": 1,
      "with_genres": id
    };

    try {
      Response response =
          await _dio.get(discoverMovie, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return MovieResponse.withError(e.toString());
    }
  }

  Future<CastResponse> getCastsFromMovie(int id) async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "page": 1,
    };

    try {
      Response response =
      await _dio.get("$getMovieDetail/$id/credits", queryParameters: params);

      return CastResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return CastResponse.withError(e.toString());
    }
  }

  Future<CrewResponse> getCrewFromMovie(int id) async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "page": 1,
    };

    try {
      Response response =
      await _dio.get("$getMovieDetail/$id/credits", queryParameters: params);

      return CrewResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return CrewResponse.withError(e.toString());
    }
  }

  Future<MovieResponse> getSimilarMovies(int id) async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "page": 1,
    };

    try {
      Response response =
      await _dio.get("$getMovieDetail/$id/similar", queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return MovieResponse.withError(e.toString());
    }
  }

  Future<MovieVideoResponse> getMovieVideos(int id) async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "page": 1,
    };

    try {
      Response response =
      await _dio.get("$getMovieDetail/$id/videos", queryParameters: params);
      return MovieVideoResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return MovieVideoResponse.withError(e.toString());
    }
  }

  Future<MovieReviewResponse> getReviewsFromMovie(int id) async {
    var params = {
      "api_key": Constants.apiKey,
      "language": "en-US",
      "page": 1,
    };

    try {
      Response response =
      await _dio.get("$getMovieDetail/$id/reviews", queryParameters: params);

      return MovieReviewResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      return MovieReviewResponse.withError(e.toString());
    }
  }

}
