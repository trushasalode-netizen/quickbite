import 'package:flutter/material.dart';

class CafeTheme {
  // Brand Colors - Popping Kiosk theme (Vibrant McDonald's Gold/Red meets Moca Espresso)
  static const Color background = Color(0xFFFAF8F5); // Warm milk cream
  static const Color surface = Color(0xFFFFFFFF);    // Pure white
  static const Color primary = Color(0xFFFFBC0D);    // Popping McDonald's Golden Yellow
  static const Color darkBronze = Color(0xFF221C19); // Deep Espresso
  static const Color textDark = Color(0xFF221C19);   // Deep Espresso
  static const Color textMuted = Color(0xFF7A6D67);  // Soft brown grey
  static const Color accentGreen = Color(0xFF2E7D32); // Fresh green
  static const Color accentRed = Color(0xFFDA291C);   // Popping McDonald's Bold Red

  // High-Contrast Premium Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      offset: const Offset(0, 8),
      blurRadius: 20,
    ),
  ];

  static List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: const Color(0xFFFFBC0D).withOpacity(0.16),
      offset: const Offset(0, 12),
      blurRadius: 28,
    ),
  ];

  // Theme Data Builder
  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: darkBronze,
        surface: surface,
        background: background,
        onPrimary: Colors.black, // Dark text on bright gold
        onSecondary: Colors.white,
        onSurface: textDark,
        onBackground: textDark,
      ),
      fontFamily: 'Georgia',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textDark,
          fontSize: 36,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          color: textDark,
          fontSize: 28,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.8,
        ),
        titleLarge: TextStyle(
          color: textDark,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.1,
        ),
        titleMedium: TextStyle(
          color: textDark,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
        bodyLarge: TextStyle(
          color: textDark,
          fontSize: 16,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          color: textMuted,
          fontSize: 14,
          height: 1.4,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: primary.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: primary.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primary, width: 2.0),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14, fontFamily: 'Georgia'),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black, // Dark contrast text on gold
          elevation: 5,
          shadowColor: primary.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            fontFamily: 'Georgia',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentRed, // Outline buttons in popping red
          side: const BorderSide(color: accentRed, width: 2.0),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            fontFamily: 'Georgia',
          ),
        ),
      ),
    );
  }
}
