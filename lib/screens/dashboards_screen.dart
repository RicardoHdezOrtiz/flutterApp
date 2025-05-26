import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:mi_primer_proyecto/utils/global_values.dart';
import 'package:sidebarx/sidebarx.dart';

// Importa tu modelo
import 'package:mi_primer_proyecto/models/popular_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Crear un ejemplo de objeto PopularModel (debes reemplazarlo por el real)
    final ejemploPopular = PopularModel(
      backdropPath: '/ruta',
      id: 1,
      originalLanguage: 'es',
      originalTitle: 'Película Ejemplo',
      overview: 'Descripción de la película ejemplo',
      popularity: 8.0,
      posterPath: '/poster.jpg',
      releaseDate: '2025-01-01',
      title: 'Película Ejemplo',
      voteAverage: 7.5,
      voteCount: 100,
    );

    return Scaffold(
      drawer: SidebarX(
        headerBuilder: (context, extended) {
          return const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
            accountName: Text('Ricardo Hernan'), 
            accountEmail: Text('ricardohdez@itcelaya.edu.mx')
          );
        },
        extendedTheme: const SidebarXTheme(width: 250),
        controller: SidebarXController(selectedIndex: 0, extended: true),
        items: [
          SidebarXItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/reto');
            },
            icon: Icons.home,
            label: 'Challenge App',
          ),
          SidebarXItem(
            onTap: () {
              Navigator.pop(context);
              // Aquí pasamos el objeto PopularModel en arguments
              Navigator.pushNamed(
                context,
                '/api',
                arguments: ejemploPopular, // PASAR EL OBJETO
              );
            },
            icon: Icons.movie,
            label: 'Popular Movies',
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Panel de control'),
      ),
      body: HawkFabMenu(
        icon: AnimatedIcons.menu_arrow,
        body: const Center(
          child: Text('Your content here :)'),
        ), 
        items: [
          HawkFabMenuItem(
            label: 'Theme Light', 
            ontap: () => GlobalValues.themeMode.value = 1, 
            icon: const Icon(Icons.light_mode),
          ),
          HawkFabMenuItem(
            label: 'Theme Dark', 
            ontap: () => GlobalValues.themeMode.value = 0, 
            icon: const Icon(Icons.dark_mode),
          ),
          HawkFabMenuItem(
            label: 'Theme Warm', 
            ontap: () => GlobalValues.themeMode.value = 2, 
            icon: const Icon(Icons.hot_tub),
          ),
        ],
      ),
    );
  }
}