import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/movie_detail_response.dart';
import 'package:tmdb/repository/repository.dart';

class GetMovieDetailsBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieDetailResponse> _subject =
  BehaviorSubject<MovieDetailResponse>();

  getMovieDetails(int movieId) async {
    MovieDetailResponse response = await _repository.getMovieDetails(movieId);
    _subject.sink.add(response);
  }

  Future<void> drainStream() async { await _subject.drain(); }

  @mustCallSuper
  dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieDetailResponse> get subject => _subject;
}

final getMovieDetailsBloc = GetMovieDetailsBloc();
