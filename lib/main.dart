import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/screens/challenge_screen.dart';
import 'package:mi_primer_proyecto/screens/contador_screens.dart';
import 'package:mi_primer_proyecto/screens/dashboards_screen.dart';
import 'package:mi_primer_proyecto/screens/detail_popular_movie.dart';
import 'package:mi_primer_proyecto/screens/login_screen.dart';
import 'package:mi_primer_proyecto/screens/popular_screen.dart';
import 'package:mi_primer_proyecto/utils/global_values.dart';
import 'package:mi_primer_proyecto/utils/theme_settings.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder(
      valueListenable: GlobalValues.themeMode,
      builder: (context, value, widget) {
        return MaterialApp(
          theme: ThemeSettings.setTheme(value),
          home: const LoginScreen(),
          routes: {
            "/dash" : (context) => const DashboardScreen(),
            "/reto" : (context) => const ChallengeScreen(),
            "/api" : (context) => const PopularScreen(),
            "/detail" : (context) => const DetailPopularMovie()
          },
        );
      }
    );
  }
}