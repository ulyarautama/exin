import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF17231F);
  static const muted = Color(0xFF78827D);
  static const canvas = Color(0xFFF7F7F2);
  static const paper = Color(0xFFFFFFFF);
  static const line = Color(0xFFE7E9E2);
  static const green = Color(0xFF456B59);
  static const lime = Color(0xFFD5E76D);
  static const peach = Color(0xFFF1B99A);
  static const lavender = Color(0xFFC8C5EA);
}

abstract final class AppSpace {
  static const xs = 6.0;
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final canvas = isDark ? const Color(0xFF090D16) : AppColors.canvas;
    final surface = isDark ? const Color(0xFF111827) : AppColors.paper;
    final ink = isDark ? const Color(0xFFF1F4FA) : AppColors.ink;
    final muted = isDark ? const Color(0xFF9AA8BE) : AppColors.muted;
    final line = isDark ? const Color(0xFF283449) : AppColors.line;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: isDark ? const Color(0xFF7797FF) : AppColors.green,
          brightness: brightness,
          surface: surface,
          onSurface: ink,
          onSurfaceVariant: muted,
          outlineVariant: line,
        ).copyWith(
          primary: isDark ? const Color(0xFF8AA5FF) : AppColors.green,
          onPrimary: isDark ? const Color(0xFF10182A) : Colors.white,
          secondary: isDark ? const Color(0xFF69D5C7) : null,
          surface: surface,
          surfaceContainer: isDark ? const Color(0xFF151E2D) : null,
          surfaceContainerHigh: isDark ? const Color(0xFF1A2435) : null,
          surfaceContainerHighest: isDark ? const Color(0xFF202C40) : null,
          outlineVariant: line,
          onSurface: ink,
          onSurfaceVariant: muted,
        );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: canvas,
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          height: 1.05,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.4,
          color: ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 25,
          height: 1.1,
          fontWeight: FontWeight.w700,
          letterSpacing: -.7,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: -.4,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        bodyLarge: TextStyle(fontSize: 15, height: 1.45, color: ink),
        bodyMedium: TextStyle(fontSize: 13, height: 1.4, color: ink),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: muted,
        ),
      ),
      dividerColor: line,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: Colors.transparent,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }
}
