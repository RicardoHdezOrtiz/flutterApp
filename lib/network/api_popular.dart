import 'package:dio/dio.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
import 'package:mi_primer_proyecto/utils/actor_model.dart';
import 'package:mi_primer_proyecto/utils/actor_model.dart';

class ApiPopular {
  final Dio dio = Dio();
  final String _apiKey = '5019e68de7bc112f4e4337a500b96c56';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  /// Obtener lista de películas populares
  Future<List<PopularModel>> getPopularMovies() async {
    final url = '$_baseUrl/movie/popular?api_key=$_apiKey&language=es-MX&page=1';
    final response = await dio.get(url);
    final res = response.data['results'] as List;
    return res.map((movie) => PopularModel.fromMap(movie)).toList();
  }

  /// Obtener el key del trailer de YouTube de una película
  Future<String?> getTrailer(int movieId) async {
    try {
      final url = '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey';
      final response = await dio.get(url);
      final results = response.data['results'] as List;

      // Buscar el primer video tipo "Trailer" en YouTube
      final trailer = results.cast<Map<String, dynamic>>().firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => {},
      );

      if (trailer.isNotEmpty && trailer.containsKey('key')) {
        return trailer['key'] as String;
      }
      return null;
    } catch (e) {
      print('Error en getTrailer: $e');
      return null;
    }
  }

  /// Obtener lista de actores (cast) de una película por su ID
  Future<List<ActorModel>> getMovieCast(int movieId) async {
    try {
      final url = '$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=es-MX';
      final response = await dio.get(url);
      final castList = response.data['cast'] as List;

      return castList.map((actor) => ActorModel.fromMap(actor)).toList();
    } catch (e) {
      print('Error en getMovieCast: $e');
      return [];
    }
  }
}