import 'package:flutter/material.dart';

class ShofTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.yellow[700],
    scaffoldBackgroundColor: const Color(0xFF0A0A0A), // أسود سينمائي
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white70),
    ),
  );
}
