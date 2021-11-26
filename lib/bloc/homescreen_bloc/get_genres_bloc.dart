import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/genreresponse.dart';
import 'package:tmdb/repository/repository.dart';

class GenreListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<GenreResponse> _subject =
      BehaviorSubject<GenreResponse>();

  getAllGenres() async {
    GenreResponse response = await _repository.getGenres();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GenreResponse> get subject => _subject;
}

final genresBloc = GenreListBloc();
