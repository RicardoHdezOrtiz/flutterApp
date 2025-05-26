import 'package:mi_primer_proyecto/models/popular_model.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  final List<PopularModel> _favorites = [];

  factory FavoritesService() {
    return _instance;
  }

  FavoritesService._internal();

  List<PopularModel> get favorites => _favorites;

  bool isFavorite(int movieId) {
    return _favorites.any((movie) => movie.id == movieId);
  }

  void toggleFavorite(PopularModel movie) {
    if (isFavorite(movie.id)) {
      _favorites.removeWhere((item) => item.id == movie.id);
    } else {
      _favorites.add(movie);
    }
  }
}