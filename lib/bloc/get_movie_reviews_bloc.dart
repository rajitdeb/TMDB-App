import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmdb/model/review_response.dart';
import 'package:tmdb/repository/repository.dart';

class MovieReviewsBloc {

  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieReviewResponse> _subject =
  BehaviorSubject<MovieReviewResponse>();

  getReviewsOfMovie(int id) async {
    MovieReviewResponse response = await _repository.getReviewsFromMovie(id);
    _subject.add(response);
  }

  Future<void> drainStream() async { await _subject.drain(); }

  @mustCallSuper
  dispose() async{
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieReviewResponse> get subject => _subject;

}

final movieReviewsBloc = MovieReviewsBloc();