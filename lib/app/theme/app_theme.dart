import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Button labels replace the text theme's style, so they carry the font and the Indian-script fallbacks themselves
/// (without them Hindi labels on filled and outlined buttons render as empty boxes where the system has no
/// Devanagari font, e.g. the web build).
const _buttonText = TextStyle(
  fontFamily: 'Inter',
  fontFamilyFallback: indicFontFallback,
  fontSize: 16,
  fontWeight: FontWeight.w700,
);

const indicFontFallback = [
  'NotoSansDevanagari',
  'NotoSansTamil',
  'NotoSansTelugu',
  'NotoSansKannada',
  'NotoSansBengali',
  'NotoSansGujarati',
  'NotoSansMalayalam',
];

class AppTheme {
  static ThemeData light() => _build(false);
  static ThemeData dark() => _build(true);

  /// Builds the theme from [AppColors] in the given brightness (the palette is switched for the build only).
  static ThemeData _build(bool dark) {
    final previous = AppColors.dark;
    AppColors.dark = dark;
    try {
      return _theme(dark ? Brightness.dark : Brightness.light);
    } finally {
      AppColors.dark = previous;
    }
  }

  static ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryFill,
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: brightness == Brightness.dark ? AppColors.ink : Colors.white,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Inter',
      // Indian scripts for AI answers in Hindi/Marathi/Tamil/Telugu/Kannada/Bengali/Gujarati/Malayalam.
      fontFamilyFallback: indicFontFallback,
    );
    final text = base.textTheme.apply(bodyColor: AppColors.textPrimary, displayColor: AppColors.textPrimary);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.1),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontFamilyFallback: indicFontFallback,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
          textStyle: _buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
          side: BorderSide(color: AppColors.border, width: 1.5),
          textStyle: _buttonText,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.surfaceTint,
      ),
    );
  }
}
