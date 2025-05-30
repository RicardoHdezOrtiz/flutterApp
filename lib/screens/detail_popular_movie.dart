import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
import 'package:mi_primer_proyecto/network/api_popular.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(movie.backdropPath),
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