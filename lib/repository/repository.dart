import 'package:untitled1/model/movie_response.dart';
import 'package:dio/dio.dart';


class MovieRepository {
  final String apiKey = "54a312146ddad24604c40591f57b3d90";
  static String mainUrl = "https://api.themoviedb.org/3";

  final Dio _dio = Dio();
  var getMoviesUrl = '$mainUrl/discover/movie';
  var getPlayingUrl = '$mainUrl/movie/now_playing';

  Future<MovieResponse> getMovies() async {
    var params = {'api_key': apiKey, 'language': 'en-US', 'page': 1};

    try {
      Response response = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }
}