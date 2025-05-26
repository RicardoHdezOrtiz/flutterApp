// lib/main.dart o donde tengas tu clase MyApp
import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/models/popular_model.dart';
import 'package:mi_primer_proyecto/screens/detail_popular_movie.dart';
import 'package:mi_primer_proyecto/screens/login_screen.dart';
import 'package:mi_primer_proyecto/screens/dashboards_screen.dart';
import 'package:mi_primer_proyecto/screens/challenge_screen.dart';
import 'package:mi_primer_proyecto/screens/popular_screen.dart';
import 'package:mi_primer_proyecto/utils/global_values.dart';
import 'package:mi_primer_proyecto/utils/theme_settings.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String accountId = 'TU_ACCOUNT_ID';
  final String sessionId = 'TU_SESSION_ID';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.themeMode,
      builder: (context, value, widget) {
        return MaterialApp(
          theme: ThemeSettings.setTheme(value),
          home: const LoginScreen(),
          routes: {
            "/dash": (context) => const DashboardScreen(),
            "/reto": (context) => const ChallengeScreen(),
            "/api": (context) => const PopularScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detalle-popular') {
              final popularModel = settings.arguments as PopularModel?;

              if (popularModel != null) {
                return MaterialPageRoute(
                  builder: (context) => DetailPopularMovie(
                    accountId: accountId,
                    sessionId: sessionId,
                    popularModel: popularModel,
                  ),
                );
              } else {
                return MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                );
              }
            }
            return null;
          },
        );
      },
    );
  }
}