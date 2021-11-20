import 'package:dio/dio.dart';
import 'package:tmdb/model/genreresponse.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/model/personresponse.dart';
import 'package:tmdb/utils/Constants.dart';

class MovieRepository {
  // http provider - just like Retrofit in Android
  final Dio _dio = Dio();

  // endpoints
  var getAllPopularMovies = "${Constants.baseUrl}/movie/popular";
  var getMovieDetail = "${Constants.baseUrl}/movie/";
  var discoverMovie = "${Constants.baseUrl}/discover/movie";
  var getNowPlaying = "${Constants.baseUrl}/movie/now_playing";
  var getAllGenres = "${Constants.baseUrl}/genre/movie/list";
  var getAllTrendingPersonality = "${Constants.baseUrl}/trending/people/week";

  // functions
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
}
