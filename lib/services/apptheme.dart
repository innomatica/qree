import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? lightScheme) {
    final scheme = lightScheme ??
        ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.yellowAccent,
        );
    return ThemeData(colorScheme: scheme, useMaterial3: true);
  }

  static ThemeData darkTheme(ColorScheme? darkScheme) {
    final scheme = darkScheme ??
        ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.yellowAccent,
        );
    return ThemeData(colorScheme: scheme, useMaterial3: true);
  }
}
