import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const hint = Color(0xFF4A5A70);
}

const lifeSystemUiOverlay = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: LifeColors.cream,
  systemNavigationBarIconBrightness: Brightness.dark,
  systemNavigationBarContrastEnforced: false,
);

ThemeData buildLifeTheme() {
  const navyStyle = TextStyle(color: LifeColors.navy);
  final scheme = ColorScheme.fromSeed(
    seedColor: LifeColors.teal,
    brightness: Brightness.light,
    primary: LifeColors.teal,
    onPrimary: Colors.white,
    secondary: LifeColors.yellow,
    onSecondary: LifeColors.navy,
    surface: Colors.white,
    onSurface: LifeColors.navy,
    onSurfaceVariant: LifeColors.hint,
    error: LifeColors.coral,
  );
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: scheme,
  );
  return base.copyWith(
    scaffoldBackgroundColor: LifeColors.cream,
    iconTheme: const IconThemeData(color: LifeColors.navy),
    primaryIconTheme: const IconThemeData(color: LifeColors.navy),
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
            color: LifeColors.navy,
          ),
          headlineMedium: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: LifeColors.navy,
          ),
          titleLarge: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: LifeColors.navy,
          ),
          bodyLarge: const TextStyle(
            fontSize: 18,
            height: 1.42,
            fontWeight: FontWeight.w500,
            color: LifeColors.navy,
          ),
          bodyMedium: const TextStyle(
            fontSize: 16,
            height: 1.35,
            fontWeight: FontWeight.w500,
            color: LifeColors.navy,
          ),
          labelLarge: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: LifeColors.navy,
          ),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: LifeColors.navy,
      elevation: 0,
      iconTheme: IconThemeData(color: LifeColors.navy),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: LifeColors.navy,
      ),
      systemOverlayStyle: lifeSystemUiOverlay,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 58),
        foregroundColor: Colors.white,
        backgroundColor: LifeColors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 56),
        foregroundColor: LifeColors.navy,
        side: const BorderSide(color: LifeColors.teal, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: LifeColors.navy,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LifeColors.tealDark,
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      margin: EdgeInsets.zero,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: LifeColors.navy,
      iconColor: LifeColors.navy,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: LifeColors.navy,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: LifeColors.navy,
      contentTextStyle: TextStyle(
        color: LifeColors.cream,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      actionTextColor: LifeColors.yellow,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: LifeColors.teal,
      selectionColor: LifeColors.teal.withValues(alpha: .28),
      selectionHandleColor: LifeColors.teal,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      prefixIconColor: LifeColors.navy,
      suffixIconColor: LifeColors.navy,
      labelStyle: navyStyle,
      floatingLabelStyle: const TextStyle(
        color: LifeColors.tealDark,
        fontWeight: FontWeight.w700,
      ),
      hintStyle: const TextStyle(color: LifeColors.hint),
      helperStyle: const TextStyle(color: LifeColors.hint),
      counterStyle: const TextStyle(color: LifeColors.hint),
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
