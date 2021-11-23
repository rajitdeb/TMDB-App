import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/person_detail_response.dart';
import 'package:tmdb/repository/repository.dart';

class GetPersonDetailsBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<PersonDetailResponse> _subject =
  BehaviorSubject<PersonDetailResponse>();

  getPersonDetails(int id) async {
    PersonDetailResponse response = await _repository.getPersonAllDetails(id);
    _subject.sink.add(response);
  }

  Future<void> drainStream() async { await _subject.drain(); }

  @mustCallSuper
  dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<PersonDetailResponse> get subject => _subject;
}

final getPersonDetailsBloc = GetPersonDetailsBloc();
