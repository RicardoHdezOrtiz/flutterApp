import 'package:dio/dio.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
class ApiPopular {
  
  final URL = 'https://api.themoviedb.org/3/movie/popular?api_key=5019e68de7bc112f4e4337a500b96c56&language=es-MX&page=1';

  Future<List<PopularModel>> getPopularMovies() async{
    final dio = Dio();
    final response = await dio.get(URL);
    final res = response.data['results'] as List;
    return res.map((movie) => PopularModel.fromMap(movie)).toList();
  }

  //Obtener detalles de la película
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final url = 'https://api.themoviedb.org/3/movie/$movieId?api_key=5019e68de7bc112f4e4337a500b96c56&language=es-MX';
    final dio = Dio();
    final response = await dio.get(url);
    return response.data;
  }

  //Obtener videos (trailers)
  Future<String?> getTrailer(int movieId) async {
    final url = 'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=5019e68de7bc112f4e4337a500b96c56';
    final dio = Dio();
    final response = await dio.get(url);
    final results = response.data['results'] as List;

    final trailer = results.firstWhere(
      (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
      orElse: () => null,
    );

    return trailer != null ? trailer['key'] : null; // este key es el que se usa para Youtube
  }

  //Obtener actores (créditos)
  Future<List<Map<String, dynamic>>> getActors(int movieId) async {
    final url = 'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=5019e68de7bc112f4e4337a500b96c56';
    final dio = Dio();
    final response = await dio.get(url);
    final cast = response.data['cast'] as List;
    return cast.take(10).map((actor) => actor as Map<String, dynamic>).toList(); // puedes limitar a los primeros 10 actores
  }

}