import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/repository/repository.dart';

class GetSimilarMoviesBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
  BehaviorSubject<MovieResponse>();

  getSimilarVideos(int id) async {
    MovieResponse response = await _repository.getSimilarMovies(id);
    _subject.sink.add(response);
  }

  Future<void> drainStream() async { await _subject.drain(); }

  @mustCallSuper
  dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final similarMoviesBloc = GetSimilarMoviesBloc();
