import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Defines the digital scrapbook color palette, typography (Inter & Poppins),
/// and styling constants for soulJournal.
class ScrapbookTheme {
  ScrapbookTheme._();

  // Background cream shades
  static const Color creamBackground = Color(0xFFF9F6F0);
  static const Color creamSubtle = Color(0xFFF5F1E9);
  static const Color creamCard = Color(0xFFFFFDF9);

  // Pastel Card Tones
  static const Color pastelMint = Color(0xFFE2EFE7);
  static const Color pastelMintAccent = Color(0xFF3C6A53);

  static const Color pastelPink = Color(0xFFF8E2E6);
  static const Color pastelPinkAccent = Color(0xFF8B4756);

  static const Color pastelLavender = Color(0xFFEBE5F7);
  static const Color pastelLavenderAccent = Color(0xFF5F5286);

  static const Color pastelButter = Color(0xFFFBF2D7);
  static const Color pastelButterAccent = Color(0xFF866E33);

  static const Color pastelSky = Color(0xFFE2EDF7);
  static const Color pastelSkyAccent = Color(0xFF456B8C);

  static const Color pastelPeach = Color(0xFFFDE8DE);
  static const Color pastelPeachAccent = Color(0xFF915944);

  // Ink & Typography Colors
  static const Color inkPrimary = Color(0xFF2B2826);
  static const Color inkSecondary = Color(0xFF6C6661);
  static const Color inkMuted = Color(0xFFA19A94);
  static const Color inkBorder = Color(0x1A2B2826);

  // Washi Tape Tints
  static const Color tapeIvory = Color(0x66FFFDF6);
  static const Color tapeMint = Color(0x44BDE0CE);
  static const Color tapePink = Color(0x44F3CCD4);
  static const Color tapeLavender = Color(0x44D7CFF0);

  // Minimal FAB color
  static const Color fabBackground = Color(0xFF242220);
  static const Color fabForeground = Color(0xFFFAF7F2);

  // Text Styles using Poppins & Inter with fallbacks
  static TextStyle poppins({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = inkPrimary,
    double letterSpacing = 0,
    double height = 1.3,
  }) {
    try {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: 'Poppins',
        fontFamilyFallback: const ['SF Pro Display', 'Segoe UI', 'Roboto', 'sans-serif'],
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );
    }
  }

  static TextStyle inter({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = inkPrimary,
    double letterSpacing = 0,
    double height = 1.5,
  }) {
    try {
      return GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: 'Inter',
        fontFamilyFallback: const ['SF Pro Text', 'Segoe UI', 'Roboto', 'sans-serif'],
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: creamBackground,
      colorScheme: const ColorScheme.light(
        surface: creamBackground,
        primary: inkPrimary,
        secondary: pastelLavenderAccent,
        onSurface: inkPrimary,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
