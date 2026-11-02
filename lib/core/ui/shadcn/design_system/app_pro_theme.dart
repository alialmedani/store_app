import 'package:flutter/material.dart';
import 'app_design_tokens.dart';

/// App themes (plain Flutter Material, styled by tokens).
/// Aurora: big rounded cards, pill buttons, pastel tiles.
/// - [dark]: deep graphite canvas, indigo-lilac accent
/// - [light]: warm off-white canvas, white cards, indigo accent
///
/// Colors come from [AppDesignTokens], so [AppDesignTokens.isDark] must match
/// the theme being built (the app root keeps them in sync).
class AppProTheme {
  AppProTheme._();

  static const String fontFamily = 'IBMPlexSansArabic';

  static ColorScheme _scheme(Brightness b) {
    final dark = b == Brightness.dark;
    return ColorScheme(
      brightness: b,
      primary: AppDesignTokens.primaryColor,
      onPrimary: AppDesignTokens.onAccentColor,
      secondary: AppDesignTokens.mutedSurfaceColor,
      onSecondary: AppDesignTokens.titleTextColor,
      error: AppDesignTokens.dangerColor,
      onError: dark ? const Color(0xFF14070A) : const Color(0xFFFFFFFF),
      surface: AppDesignTokens.backgroundColor,
      onSurface: AppDesignTokens.titleTextColor,
      outline: AppDesignTokens.borderColor,
    );
  }

  static ThemeData _build(Brightness b) {
    final base = ThemeData(brightness: b, useMaterial3: true);
    return base.copyWith(
      colorScheme: _scheme(b),
      scaffoldBackgroundColor: AppDesignTokens.backgroundColor,
      canvasColor: AppDesignTokens.backgroundColor,
      dividerColor: AppDesignTokens.hairline,
      iconTheme: IconThemeData(color: AppDesignTokens.titleTextColor),
      textTheme: base.textTheme.apply(
        fontFamily: fontFamily,
        bodyColor: AppDesignTokens.titleTextColor,
        displayColor: AppDesignTokens.titleTextColor,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppDesignTokens.cardColor,
        modalBackgroundColor: AppDesignTokens.cardColor,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppDesignTokens.primaryColor
              : AppDesignTokens.surface3Color,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }

  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData get light => _build(Brightness.light);
}
