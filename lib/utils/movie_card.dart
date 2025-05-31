import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
import 'package:mi_primer_proyecto/screens/detail_popular_movie.dart'; // ajusta ruta si es necesario

class MovieCard extends StatelessWidget {
  final PopularModel movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a detalle enviando la película
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPopularMovie(),
            settings: RouteSettings(arguments: movie),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Hero(
            tag: 'poster-${movie.id}', // mismo tag que en detalle
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}