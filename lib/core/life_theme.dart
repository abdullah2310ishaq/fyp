import 'package:flutter/material.dart';

abstract final class LifeColors {
  static const teal = Color(0xFF177E78);
  static const tealDark = Color(0xFF0D5F5A);
  static const mint = Color(0xFFDFF5EE);
  static const yellow = Color(0xFFFFC857);
  static const coral = Color(0xFFF57C73);
  static const cream = Color(0xFFFFF9F0);
  static const navy = Color(0xFF1F3049);
  static const green = Color(0xFF4EAD7B);
  static const sky = Color(0xFFDCEEFF);
  static const purple = Color(0xFF7165A8);
}

ThemeData buildLifeTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: LifeColors.teal,
    primary: LifeColors.teal,
    secondary: LifeColors.yellow,
    surface: Colors.white,
    error: LifeColors.coral,
  );
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  return base.copyWith(
    scaffoldBackgroundColor: LifeColors.cream,
    textTheme: base.textTheme
        .apply(
          bodyColor: LifeColors.navy,
          displayColor: LifeColors.navy,
          fontFamily: 'sans-serif',
        )
        .copyWith(
          headlineLarge: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
          headlineMedium: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
          titleLarge: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
          bodyLarge: const TextStyle(
            fontSize: 18,
            height: 1.42,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: const TextStyle(
            fontSize: 16,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
          labelLarge: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: LifeColors.navy,
      elevation: 0,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 58),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 56),
        side: const BorderSide(color: LifeColors.teal, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE4E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: LifeColors.teal, width: 2),
      ),
    ),
  );
}
