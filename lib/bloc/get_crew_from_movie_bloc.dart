import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/crew_response.dart';
import 'package:tmdb/repository/repository.dart';

class CrewFromMovieBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<CrewResponse> _subject =
  BehaviorSubject<CrewResponse>();

  getCrewFromMovie(int id) async {
    CrewResponse response = await _repository.getCrewFromMovie(id);
    _subject.sink.add(response);
  }

  Future<void> drainStream() async { await _subject.drain(); }

  @mustCallSuper
  dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<CrewResponse> get subject => _subject;
}

final crewFromMovieBloc = CrewFromMovieBloc();
