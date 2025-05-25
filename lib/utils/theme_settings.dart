import 'package:flutter/material.dart';

class ThemeSettings {
  
  static ThemeData? setTheme(int opcTheme){
    switch(opcTheme){
      case 0: return ThemeData.dark();
      case 1: return ThemeData.light();
      case 2: final theme = ThemeData.light().copyWith(
              colorScheme: const ColorScheme(
                brightness: Brightness.light, 
                primary: Color.fromARGB(255, 168, 162, 109), 
                onPrimary: Colors.blue, 
                secondary: Colors.yellow, 
                onSecondary: Colors.orange, 
                error: Colors.red, 
                onError: Colors.red, 
                surface: Colors.green, 
                onSurface: Colors.white
              )
            );
            return theme;
    }
    return null;
  }  
}