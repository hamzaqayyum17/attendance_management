import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

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
  static InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    String? helper, // small grey text under the field
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: textGrey, fontSize: 14),
      helperText: helper,
      prefixIcon: Icon(icon, color: textGrey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: border(fieldBorder),
      focusedBorder: border(primary, 1.5),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red, 1.5),
    );
  }
}
