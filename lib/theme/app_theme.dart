import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color navy = Color(0xFF0F2A5C);
  static const Color primary = Color(0xFF0B63E5);
  static const Color fieldBorder = Color(0xFFDDE5F0);
  static const Color textGrey = Color(0xFF6B7A90);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    scaffoldBackgroundColor: Colors.white,
    // Every ElevatedButton in the app gets this style automatically.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52), // full width, 52 tall
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
