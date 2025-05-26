import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_primer_proyecto/models/favorites_service.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();

  List<PopularModel> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      // Obtener favoritos desde la API usando el método que debes implementar en FavoritesService
      final favoritesFromApi = await _favoritesService.fetchFavoritesFromApi();

      setState(() {
        favoriteMovies = favoritesFromApi;
      });
    } catch (e) {
      print('Error al cargar favoritos: $e');
    }
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