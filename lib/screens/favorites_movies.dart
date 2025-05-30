import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
import 'package:mi_primer_proyecto/models/favorite_service.dart';

class FavoritesMovies extends StatelessWidget {
  const FavoritesMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PopularModel> favoriteMovies = FavoriteService.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas Favoritas'),
      ),
      body: favoriteMovies.isEmpty
          ? const Center(child: Text('No hay películas favoritas.'))
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: movie,
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen grande arriba usando FadeInImage con placeholder
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: FadeInImage(
                            placeholder: const AssetImage('assets/loading.gif'), // tu gif de carga
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}', // URL completa
                            ),
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, size: 50),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                movie.releaseDate,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}