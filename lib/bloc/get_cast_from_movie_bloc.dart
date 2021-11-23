import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/cast_response.dart';
import 'package:tmdb/repository/repository.dart';

class CastFromMovieBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<CastResponse> _subject =
  BehaviorSubject<CastResponse>();

  getCastsFromMovie(int id) async {
    CastResponse response = await _repository.getCastsFromMovie(id);
    _subject.sink.add(response);
  }

  Future<void> drainStream() async { await _subject.drain(); }

  @mustCallSuper
  dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<CastResponse> get subject => _subject;
}

final castFromMovieBloc = CastFromMovieBloc();
