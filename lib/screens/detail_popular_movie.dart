import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
import 'package:mi_primer_proyecto/network/api_popular.dart';
import 'package:mi_primer_proyecto/models/favorite_service.dart';
import 'package:mi_primer_proyecto/utils/star_rating.dart';
import 'package:mi_primer_proyecto/utils/actor_model.dart';
import 'package:mi_primer_proyecto/models/actor_service.dart';

class DetailPopularMovie extends StatefulWidget {
  const DetailPopularMovie({super.key});

  @override
  State<DetailPopularMovie> createState() => _DetailPopularMovieState();
}

class _DetailPopularMovieState extends State<DetailPopularMovie> {
  late PopularModel movie;
  String? trailerKey;
  YoutubePlayerController? _youtubeController;

  List<ActorModel> _cast = [];
  bool _isLoadingCast = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movie = ModalRoute.of(context)!.settings.arguments as PopularModel;
    _loadTrailer();
    _loadCast();
  }

  Future<void> _loadTrailer() async {
    final api = ApiPopular();
    final key = await api.getTrailer(movie.id);
    if (key != null) {
      setState(() {
        trailerKey = key;
        _youtubeController = YoutubePlayerController(
          initialVideoId: key,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      });
    }
  }

  Future<void> _loadCast() async {
    final cast = await getMovieCast(movie.id);
    setState(() {
      _cast = cast;
      _isLoadingCast = false;
    });
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Stack(
        children: [
          // Imagen de fondo difuminada
          Positioned.fill(
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        movie.backdropPath,
                        width: double.infinity,
                        height: 230,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              FavoriteService.toggleFavorite(movie);
                            });

                            final isNowFavorite = FavoriteService.isFavorite(movie);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isNowFavorite
                                    ? 'Película agregada a favoritos'
                                    : 'Película eliminada de favoritos'),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 4, 4, 4).withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              FavoriteService.isFavorite(movie)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: const Color.fromARGB(255, 82, 255, 111),
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ⭐ ESTRELLAS DE RATING
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: StarRating(
                      rating: movie.voteAverage / 2,
                    ),
                  ),

                  // DESCRIPCIÓN
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      movie.overview,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  // REPARTO
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Reparto',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: _isLoadingCast
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _cast.length,
                            itemBuilder: (context, index) {
                              final actor = _cast[index];
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: actor.profilePath != null
                                          ? Image.network(
                                              'https://image.tmdb.org/t/p/w185${actor.profilePath}',
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(Icons.person, size: 60, color: Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      actor.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 20),

                  // TRAILER
                  if (trailerKey?.isNotEmpty == true && _youtubeController != null)
                    YoutubePlayer(
                      controller: _youtubeController!,
                      showVideoProgressIndicator: true,
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Trailer no disponible',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}