class MovieModel {
  final int id;
  final String title;
  final String posterPath;
  final String overview;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  // Método para crear un MovieModel desde un Map (JSON)
  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'],
      title: map['title'],
      posterPath: map['poster_path'] ?? '', // si no viene la imagen, vacio
      overview: map['overview'] ?? '',
    );
  }
}