import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_primer_proyecto/models/popular_model.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  final List<PopularModel> _favorites = [];

  final String apiKey = 'TU_API_KEY';
  final String accountId = 'TU_ACCOUNT_ID';
  final String sessionId = 'TU_SESSION_ID';

  factory FavoritesService() {
    return _instance;
  }

  FavoritesService._internal();

  List<PopularModel> get favorites => _favorites;

  bool isFavorite(int movieId) {
    return _favorites.any((movie) => movie.id == movieId);
  }

  Future<void> toggleFavorite(PopularModel movie) async {
    final currentlyFavorite = isFavorite(movie.id);

    final url = Uri.parse(
      'https://api.themoviedb.org/3/account/$accountId/favorite?api_key=$apiKey&session_id=$sessionId',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movie.id,
        'favorite': !currentlyFavorite, // Cambia estado en API
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (currentlyFavorite) {
        _favorites.removeWhere((item) => item.id == movie.id);
      } else {
        _favorites.add(movie);
      }
      print('✅ Favorito actualizado en API: ${movie.title}');
    } else {
      print('❌ Error al actualizar favorito: ${response.body}');
      throw Exception('Fallo al actualizar favorito en la API');
    }
  }

  Future<List<PopularModel>> fetchFavoritesFromApi() async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/account/$accountId/favorite/movies?api_key=$apiKey&session_id=$sessionId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;

      _favorites.clear();
      _favorites.addAll(results.map((json) => PopularModel.fromJson(json as Map<String, dynamic>)).toList());

      return _favorites;
    } else {
      throw Exception('Error al cargar favoritos desde API');
    }
  }
}