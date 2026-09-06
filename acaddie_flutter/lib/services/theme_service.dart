import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _keyIsDark = 'acaddie_is_dark_theme';
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_keyIsDark) ?? true;
    themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> toggleTheme() async {
    final newMode = themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    themeModeNotifier.value = newMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDark, newMode == ThemeMode.dark);
  }

  static bool get isDark => themeModeNotifier.value == ThemeMode.dark;

  // ── DARK THEME ─────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF060D1A),
      cardColor: const Color(0xFF0F172A),
      dividerColor: Colors.white.withValues(alpha: 0.08),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF0284C7),
        secondary: Color(0xFF38BDF8),
        surface: Color(0xFF0F172A),
        onSurface: Colors.white,
        onPrimary: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
    );
  }

  // ── LIGHT THEME ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0284C7),
        secondary: Color(0xFF0369A1),
        surface: Colors.white,
        onSurface: Color(0xFF0F172A),
        onPrimary: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      useMaterial3: true,
    );
  }
}

/// Helper class for typography across all screens
class AppTypography {
  /// Cormorant Garamond SemiBold for all Headings
  static TextStyle heading({
    required double fontSize,
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Inter for body, captions, labels, buttons
  static TextStyle body({
    required double fontSize,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
