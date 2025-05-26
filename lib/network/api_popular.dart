import 'package:dio/dio.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';

class ApiPopular {
  final String apiKey = '5019e68de7bc112f4e4337a500b96c56';
  final String language = 'es-MX';
  final String baseUrl = 'https://api.themoviedb.org/3';
  final Dio dio = Dio();

  final String accountId;
  final String sessionId;

  ApiPopular({required this.accountId, required this.sessionId});

  Future<List<PopularModel>> getPopularMovies() async {
    try {
      final url = '$baseUrl/movie/popular?api_key=$apiKey&language=$language&page=1';
      final response = await dio.get(url);
      final res = response.data['results'] as List;
      return res.map((movie) => PopularModel.fromJson(movie)).toList();
    } catch (e) {
      print('Error en getPopularMovies: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getMovieDetails(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId?api_key=$apiKey&language=$language';
      final response = await dio.get(url);
      return response.data;
    } catch (e) {
      print('Error en getMovieDetails: $e');
      return null;
    }
  }

  Future<String?> getTrailer(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId/videos?api_key=$apiKey';
      final response = await dio.get(url);
      final results = response.data['results'] as List;

      // Manejo seguro para buscar el trailer
      final trailer = results.cast<Map<String, dynamic>>().firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => {},
      );

      // Validar que trailer no esté vacío ni sea null
      if (trailer.isNotEmpty && trailer.containsKey('key')) {
        return trailer['key'] as String;
      }
      return null;
    } catch (e) {
      print('Error en getTrailer: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getActors(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId/credits?api_key=$apiKey';
      final response = await dio.get(url);
      final cast = response.data['cast'] as List;
      // Toma máximo 10 actores
      return cast.take(10).map((actor) => actor as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error en getActors: $e');
      return [];
    }
  }

  Future<bool> toggleFavorite(int movieId, bool favorite) async {
    try {
      final url = '$baseUrl/account/$accountId/favorite?api_key=$apiKey&session_id=$sessionId';
      final data = {
        "media_type": "movie",
        "media_id": movieId,
        "favorite": favorite,
      };
      final response = await dio.post(url, data: data);

      // Verifica si fue exitoso con status code o status_code específico
      if (response.statusCode == 200 || 
          response.data['status_code'] == 1 || 
          response.data['status_code'] == 12) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error en toggleFavorite: $e');
      return false;
    }
  }
}