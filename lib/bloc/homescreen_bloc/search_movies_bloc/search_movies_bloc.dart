import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/repository/repository.dart';

class SearchMoviesBloc {

  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject<MovieResponse>();

  searchAMovie(String searchQuery) async {
    MovieResponse response = await _repository.searchAMovie(searchQuery);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;

}

final searchMoviesBloc = SearchMoviesBloc();