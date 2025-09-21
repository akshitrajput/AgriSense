import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF4A6F26);
  static const Color accentColor = Color(0xFF76B041);
  static const Color backgroundColor = Color(0xFFF9F8F4);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF3D3D3D);
  static const Color subTextColor = Color(0xFF5B5B5B);
  static const Color healthyColor = Color(0xFF76B041);
  static const Color affectedColor = Color(0xFFC05746);
  static const Color borderColor = Color(0xFFE0E0E0);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
      surface: cardColor,
      error: affectedColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textColor,
      onSurface: textColor,
      onError: Colors.white,
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
    // CardTheme section has been removed.
  );
}