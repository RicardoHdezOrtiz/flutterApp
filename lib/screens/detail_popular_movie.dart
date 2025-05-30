import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
import 'package:mi_primer_proyecto/network/api_popular.dart';
import 'package:mi_primer_proyecto/models/favorite_service.dart';

class DetailPopularMovie extends StatefulWidget {
  const DetailPopularMovie({super.key});

  @override
  State<DetailPopularMovie> createState() => _DetailPopularMovieState();
}

class _DetailPopularMovieState extends State<DetailPopularMovie> {
  late PopularModel movie;
  String? trailerKey;

  YoutubePlayerController? _youtubeController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movie = ModalRoute.of(context)!.settings.arguments as PopularModel;
    _loadTrailer();
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

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite = FavoriteService.isFavorite(movie);

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 👇 Aquí insertamos tu Stack con la imagen y el botón de favoritos
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
                      final wasFavorite = FavoriteService.isFavorite(movie);
                      setState(() {
                        FavoriteService.toggleFavorite(movie);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(wasFavorite
                              ? 'Película eliminada de favoritos'
                              : 'Película agregada a favoritos'),
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
                        color: Colors.white.withOpacity(0.9),
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
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color.fromARGB(255, 82, 255, 111),
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // 👇 Resto del contenido de detalle
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                movie.overview,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            if (trailerKey != null && _youtubeController != null)
              YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
              )
            else
              const Text('Trailer no disponible'),
          ],
        ),
      ),
    );
  }
}