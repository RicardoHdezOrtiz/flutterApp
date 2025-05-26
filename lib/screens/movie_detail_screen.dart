import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/network/api_popular.dart';
import 'package:mi_primer_proyecto/models/favorites_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mi_primer_proyecto/widget/star_rating.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final api = ApiPopular(accountId: 'TU_ACCOUNT_ID', sessionId: 'TU_SESSION_ID');
  final FavoritesService _favoritesService = FavoritesService();

  Map<String, dynamic>? movieData;
  String? trailerKey;
  List<Map<String, dynamic>> actors = [];
  bool isFavorite = false;

  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final movieDetails = await api.getMovieDetails(widget.movieId);
      final trailer = await api.getTrailer(widget.movieId);
      final movieActors = await api.getActors(widget.movieId);
      final favoriteStatus = _favoritesService.isFavorite(widget.movieId);

      if (_youtubeController != null) {
        _youtubeController!.dispose();
      }

      setState(() {
        movieData = movieDetails;
        trailerKey = trailer;
        actors = movieActors;
        isFavorite = favoriteStatus;

        if (trailerKey != null && trailerKey!.isNotEmpty) {
          _youtubeController = YoutubePlayerController(
            initialVideoId: trailerKey!,
            flags: const YoutubePlayerFlags(autoPlay: false),
          );
        }
      });
    } catch (e) {
      debugPrint("Error al cargar datos: $e");
    }
  }

  void toggleFavorite() {
    if (movieData == null) return;

    final movie = PopularModel(
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
    );

    _favoritesService.toggleFavorite(movie);

    setState(() {
      isFavorite = _favoritesService.isFavorite(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (movieData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final posterPath = movieData!['poster_path'];
    final posterUrl = (posterPath != null && posterPath.isNotEmpty)
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(movieData!['title'] ?? 'Sin título'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorite,
            color: Colors.red,
          )
        ],
      ),
      body: Stack(
        children: [
          if (posterUrl != null)
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
            )
          else
            Container(color: Colors.black54),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_youtubeController != null)
                  YoutubePlayer(
                    controller: _youtubeController!,
                    showVideoProgressIndicator: true,
                  ),
                const SizedBox(height: 16),
                Text(
                  movieData!['overview'] ?? 'Sin descripción disponible.',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                StarRating(
                  rating: (movieData!['vote_average'] as num?)?.toDouble() != null
                      ? (movieData!['vote_average'] / 2)
                      : 0.0,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Actores:",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: actors.length,
                    itemBuilder: (context, index) {
                      final actor = actors[index];
                      final profilePath = actor['profile_path'];
                      final profileUrl = (profilePath != null && profilePath.isNotEmpty)
                          ? 'https://image.tmdb.org/t/p/w200$profilePath'
                          : null;

                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  profileUrl != null ? NetworkImage(profileUrl) : null,
                              backgroundColor: Colors.grey,
                              child: profileUrl == null
                                  ? const Icon(Icons.person, color: Colors.white, size: 35)
                                  : null,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              actor['name'] ?? 'Desconocido',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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