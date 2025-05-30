import 'package:mi_primer_proyecto/models/popular_model.dart';

class FavoriteService {
  // Lista estática para almacenar las películas favoritas
  static final List<PopularModel> _favorites = [];

  // Getter para acceder a la lista desde otras partes
  static List<PopularModel> get favorites => _favorites;

  // Método para verificar si una película está en favoritos
  static bool isFavorite(PopularModel movie) {
    return _favorites.any((item) => item.id == movie.id);
  }

  // Método para agregar o quitar una película
  static void toggleFavorite(PopularModel movie) {
    if (isFavorite(movie)) {
      _favorites.removeWhere((item) => item.id == movie.id);
    } else {
      _favorites.add(movie);
    }
  }
}