import 'package:flutter/material.dart';
import 'app_design_tokens.dart';

/// App themes (plain Flutter Material, styled by tokens).
/// "Ink & Ember": flat paper/ink cards with Line hairlines, one Ember accent.
/// - [light]: warm paper canvas (#EEECE7), white cards, Ember accent, Ink text
/// - [dark]: near-black ground (#121212), lifted #1C1C1C cards, same Ember
///
/// Colors come from [AppDesignTokens], so [AppDesignTokens.isDark] must match
/// the theme being built (the app root keeps them in sync).
class AppProTheme {
  AppProTheme._();

  static const String fontFamily = 'IBMPlexSansArabic';

  static ColorScheme _scheme(Brightness b) {
    return ColorScheme(
      brightness: b,
      primary: AppDesignTokens.primaryColor,
      onPrimary: AppDesignTokens.onAccentColor,
      secondary: AppDesignTokens.mutedSurfaceColor,
      onSecondary: AppDesignTokens.titleTextColor,
      error: AppDesignTokens.dangerColor,
      // Dark theme's danger is a light coral, so its foreground is ink;
      // light theme's danger is a deep red, so its foreground is white.
      onError: AppDesignTokens.isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFFFFFF),
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
