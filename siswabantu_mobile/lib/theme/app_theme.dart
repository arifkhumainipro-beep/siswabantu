import 'package:flutter/material.dart';

class AppTheme {
  // Palet Warna Jenama SiswaBantu (Tema Merah & Kuning / Emas Elegan)
  static const Color primary = Color(0xFFC8102E); // Crimson Red Utama
  static const Color primaryIndigo = Color(0xFFC8102E); // Alias untuk keserasian
  static const Color primaryDark = Color(0xFF991B1B); // Merah Pekat Diraja
  static const Color primaryDeep = Color(0xFF7F1D1D); // Burgundy Deep
  static const Color primaryLight = Color(0xFFEF4444); // Scarlet / Rose Terang
  static const Color primarySurface = Color(0xFFFEF2F2); // Latar Lembut Mawar

  // Aksen Kuning & Emas Diraja (Royal Amber & Gold)
  static const Color accent = Color(0xFFF59E0B); // Amber / Gold Utama
  static const Color accentCyan = Color(0xFFF59E0B); // Alias untuk keserasian
  static const Color accentLight = Color(0xFFFFFBEB); // Latar Lembut Emas
  static const Color amberWarm = Color(0xFFF59E0B); // Amber 500
  static const Color goldYellow = Color(0xFFFFCC00); // Kuning Emas Cerah
  static const Color emeraldSuccess = Color(0xFF10B981); // Emerald 500
  static const Color roseDanger = Color(0xFFF43F5E); // Rose 500

  // Alias Warna Merah & Kuning Elegan
  static const Color themeRed = Color(0xFFC8102E);
  static const Color themeRedDark = Color(0xFF991B1B);
  static const Color themeRedLight = Color(0xFFEF4444);
  static const Color themeYellow = Color(0xFFFFCC00);
  static const Color themeGold = Color(0xFFF59E0B);
  static const Color themeGoldLight = Color(0xFFFDE047);
  static const Color themeAmber = Color(0xFFD97706);

  // Keserasian ke belakang
  static const Color selangorRed = Color(0xFFC8102E);
  static const Color selangorRedDark = Color(0xFF991B1B);
  static const Color selangorRedLight = Color(0xFFEF4444);
  static const Color selangorYellow = Color(0xFFFFCC00);
  static const Color selangorGold = Color(0xFFF59E0B);
  static const Color selangorGoldLight = Color(0xFFFDE047);
  static const Color selangorAmber = Color(0xFFD97706);

  // Skala Warna Neutral & Slate Profesional
  static const Color slateDark = Color(0xFF0F172A); // Slate 900
  static const Color slateNavy = Color(0xFF1E293B); // Slate 800
  static const Color slateCard = Color(0xFF334155); // Slate 700
  static const Color slateMuted = Color(0xFF64748B); // Slate 500
  static const Color slateLight = Color(0xFF94A3B8); // Slate 400
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color surfaceLight = Color(0xFFF8FAFC); // Slate 50
  static const Color scaffoldBg = Color(0xFFF8FAFC); // Clean Canvas

  // Kecerunan Jenama Merah & Kuning / Emas Profesional
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF881337), // Crimson Deep
      Color(0xFFC8102E), // Vibrant Red
      Color(0xFFDC2626), // Scarlet
    ],
  );

  static const LinearGradient redGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF881337),
      Color(0xFFC8102E),
      Color(0xFFF59E0B),
    ],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF59E0B),
      Color(0xFFFFCC00),
    ],
  );

  static const LinearGradient selangorHeaderGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF991B1B),
      Color(0xFFC8102E),
      Color(0xFFF59E0B),
    ],
  );

  static const LinearGradient selangorCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7F1D1D),
      Color(0xFFB91C1C),
      Color(0xFFDC2626),
    ],
  );

  static const LinearGradient selangorDualGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFC8102E),
      Color(0xFFFFCC00),
    ],
  );

  static const LinearGradient selangorGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF59E0B),
      Color(0xFFFFCC00),
    ],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E293B),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFDC2626),
      Color(0xFFF59E0B),
    ],
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      surface: surfaceLight,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: scaffoldBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: borderLight, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: slateMuted),
      hintStyle: const TextStyle(fontSize: 13, color: slateLight),
    ),
  );
}
