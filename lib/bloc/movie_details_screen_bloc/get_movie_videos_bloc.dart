import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/movie_video_response.dart';
import 'package:tmdb/repository/repository.dart';

class MovieVideosBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieVideoResponse> _subject =
  BehaviorSubject<MovieVideoResponse>();

  getMovieVideos(int id) async {
    MovieVideoResponse response = await _repository.getMovieVideos(id);
    _subject.sink.add(response);
  }

  Future<void> drainStream() async { await _subject.drain(); }

  @mustCallSuper
  dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieVideoResponse> get subject => _subject;
}

final movieVideosBloc = MovieVideosBloc();
