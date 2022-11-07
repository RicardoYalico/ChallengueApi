import 'package:untitled1/model/movie_response.dart';
import 'package:untitled1/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesListBloc {
  final MovieRepository _movieRepository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
  BehaviorSubject<MovieResponse>();

  getMovies() async {
    MovieResponse response = await _movieRepository.getMovies().then((res)=> res);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final moviesBloc = MoviesListBloc();