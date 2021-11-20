import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/personresponse.dart';
import 'package:tmdb/repository/repository.dart';

class PersonsListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<PersonResponse> _subject =
  BehaviorSubject<PersonResponse>();

  getAllGenres() async {
    PersonResponse response = await _repository.getTrendingPeople();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<PersonResponse> get subject => _subject;
}

final personsBloc = PersonsListBloc();
