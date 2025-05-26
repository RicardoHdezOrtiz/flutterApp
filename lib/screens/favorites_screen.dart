import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/network/api_popular.dart';
import 'package:mi_primer_proyecto/screens/detail_popular_movie.dart';
import 'package:mi_primer_proyecto/models/favorites_service.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';

  class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  final ApiPopular _api = ApiPopular();

  List<PopularModel> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
  final allMovies = await _api.getPopularMovies();
  final favorites = _favoritesService.favorites;

  // Filtra solo las películas cuyos ID están en la lista de favoritos
  final filtered = allMovies.where((movie) =>
    favorites.any((fav) => fav.id == movie.id)
  ).toList();

  setState(() {
    favoriteMovies = filtered;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),
      body: favoriteMovies.isEmpty
          ? const Center(child: Text('No tienes películas favoritas 😢'))
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: movie,
                    );
                  },
                );
              },
            ),
    );
  }
}