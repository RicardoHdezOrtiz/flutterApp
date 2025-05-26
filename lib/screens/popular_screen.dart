import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
import 'package:mi_primer_proyecto/network/api_popular.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  late ApiPopular apiPopular;

  @override
  void initState() {
    super.initState();
    // Inicializa ApiPopular con tus datos reales
    apiPopular = ApiPopular(
      accountId: 'TU_ACCOUNT_ID',  // Reemplaza con tu accountId real
      sessionId: 'TU_SESSION_ID',  // Reemplaza con tu sessionId real
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<PopularModel>>(
        future: apiPopular.getPopularMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay películas populares'));
          } else {
            final movies = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _itemPopular(movies[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _itemPopular(PopularModel popular) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          FadeInImage(
            placeholder: const AssetImage('assets/loading.gif'),
            image: NetworkImage(popular.backdropPath),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: 70,
            width: double.infinity,
            color: const Color.fromARGB(136, 19, 74, 122),
            child: ListTile(
              // Cambié la ruta para que coincida con la que debes definir en main.dart
              onTap: () => Navigator.pushNamed(
                context,
                '/detalle-popular',  // Cambia '/detail' por '/detalle-popular'
                arguments: popular,    // Aquí pasas el objeto popular para usar en la pantalla detalle
              ),
              title: Text(
                popular.title,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.chevron_right, size: 30, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}