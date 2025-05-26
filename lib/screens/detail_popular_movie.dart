// lib/screens/detail_popular_movie.dart
import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
import 'package:mi_primer_proyecto/network/api_popular.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPopularMovie extends StatefulWidget {
  final String accountId;
  final String sessionId;
  final PopularModel popularModel;  // Recibe el objeto aquí

  const DetailPopularMovie({
    super.key,
    required this.accountId,
    required this.sessionId,
    required this.popularModel,
  });

  @override
  State<DetailPopularMovie> createState() => _DetailPopularMovieState();
}

class _DetailPopularMovieState extends State<DetailPopularMovie> {
  late ApiPopular apiPopular;

  String description = '';
  String? trailerUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    apiPopular = ApiPopular(
      accountId: widget.accountId,
      sessionId: widget.sessionId,
    );

    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final details = await apiPopular.getMovieDetails(widget.popularModel.id);
      final trailerKey = await apiPopular.getTrailer(widget.popularModel.id);

      setState(() {
        description = details?['overview'] ?? 'Sin descripción disponible';
        trailerUrl = trailerKey != null
            ? 'https://www.youtube.com/watch?v=$trailerKey'
            : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        description = 'Error al cargar detalles';
        trailerUrl = null;
        isLoading = false;
      });
    }
  }

  void _launchTrailer() async {
    if (trailerUrl != null) {
      final uri = Uri.parse(trailerUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el trailer')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cargando...')),
        body: Center(
          child: Image.asset(
            'assets/images/loading.gif',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.popularModel.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.popularModel.backdropPath,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Error al cargar la imagen'));
              },
            ),
            const SizedBox(height: 16),
            Text(
              widget.popularModel.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            trailerUrl != null
                ? ElevatedButton(
                    onPressed: _launchTrailer,
                    child: const Text('Ver Trailer'),
                  )
                : const Text('No hay trailer disponible'),
          ],
        ),
      ),
    );
  }
}