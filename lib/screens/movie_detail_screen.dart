import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/network/api_popular.dart';
import 'package:mi_primer_proyecto/models/favorites_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mi_primer_proyecto/widget/star_rating.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';  // Asegúrate de importar tu modelo PopularModel

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final api = ApiPopular();
  final FavoritesService _favoritesService = FavoritesService();

  Map<String, dynamic>? movieData;
  String? trailerKey;
  List<Map<String, dynamic>> actors = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    movieData = await api.getMovieDetails(widget.movieId);
    trailerKey = await api.getTrailer(widget.movieId);
    actors = await api.getActors(widget.movieId);

    // Verificamos si ya es favorito
    isFavorite = _favoritesService.isFavorite(widget.movieId);

    setState(() {});
  }

  void toggleFavorite() {
    if (movieData == null) return;

    setState(() {
      isFavorite = !isFavorite;
      _favoritesService.toggleFavorite(
        PopularModel(
          id: widget.movieId,
          title: movieData!['title'] ?? '',
          overview: movieData!['overview'] ?? '',
          posterPath: movieData!['poster_path'] ?? '',
          backdropPath: movieData!['backdrop_path'] ?? '',
          voteAverage: (movieData!['vote_average'] as num?)?.toDouble() ?? 0.0,
          voteCount: movieData!['vote_count'] ?? 0,
          popularity: (movieData!['popularity'] as num?)?.toDouble() ?? 0.0,
          releaseDate: movieData!['release_date'] ?? '',
          originalTitle: movieData!['original_title'] ?? '',
          originalLanguage: movieData!['original_language'] ?? '',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (movieData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final posterUrl = 'https://image.tmdb.org/t/p/w500${movieData!['poster_path']}';

    return Scaffold(
      appBar: AppBar(
        title: Text(movieData!['title']),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorite,
          )
        ],
      ),
      body: Stack(
        children: [
          // Fondo difuminado
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(posterUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (trailerKey != null)
                  YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: trailerKey!,
                      flags: const YoutubePlayerFlags(autoPlay: false),
                    ),
                    showVideoProgressIndicator: true,
                  ),
                const SizedBox(height: 16),
                Text(
                  movieData!['overview'],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                StarRating(rating: movieData!['vote_average'] / 2),
                const SizedBox(height: 16),
                const Text("Actores:", style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: actors.length,
                    itemBuilder: (context, index) {
                      final actor = actors[index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                'https://image.tmdb.org/t/p/w200${actor['profile_path'] ?? ''}',
                              ),
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              actor['name'],
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}