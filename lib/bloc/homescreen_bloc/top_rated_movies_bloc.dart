import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/repository/repository.dart';

class TopRatedMoviesBloc {

  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subjectInIndia = BehaviorSubject<MovieResponse>();
  final BehaviorSubject<MovieResponse> _subjectInUS = BehaviorSubject<MovieResponse>();

  getTopRatedMoviesInIndia() async {
    MovieResponse response = await _repository.getTopRatedMoviesInIndia();
    _subjectInIndia.sink.add(response);
  }

  getTopRatedRMoviesInUs() async {
    MovieResponse response = await _repository.getTopRatedMoviesInUs();
    _subjectInUS.sink.add(response);
  }

  dispose() {
    _subjectInIndia.close();
    _subjectInUS.close();
  }

  BehaviorSubject<MovieResponse> get subjectInIndia => _subjectInIndia;
  BehaviorSubject<MovieResponse> get subjectInUS => _subjectInUS;

}

final topRatedMoviesBloc = TopRatedMoviesBloc();