import 'package:flutter/widgets.dart' as fw;

/// Design tokens for consistent UI across the app
/// Aurora design (light + dark): glass-like cards with hairline glass borders,
/// violet->blue gradient accent with soft glow, rounded-rect controls (18),
/// tinted icon tiles, restrained motion.
class AppDesignTokens {
  // ========== Spacing ==========
  static const double screenPaddingHorizontal = 16.0;
  static const double sectionGap = 20.0;
  static const double cardGap = 16.0;
  static const double itemGap = 12.0;
  static const double smallGap = 8.0;
  static const double tinyGap = 4.0;

  // ========== Border Radius ==========
  static const double cardRadius = 24.0;
  static const double buttonRadius = 18.0;
  static const double inputRadius = 18.0;
  static const double badgeRadius = 10.0;
  static const double pillRadius = 99.0;
  static const double iconBoxRadius = 16.0;

  // ========== Component Heights ==========
  static const double inputHeight = 54.0;
  static const double primaryButtonHeight = 54.0;
  static const double secondaryButtonHeight = 46.0;
  static const double iconBoxSize = 52.0;
  static const double iconBoxSmall = 44.0;
  static const double headerActionButtonSize = 46.0;

  // ========== List Bottom Padding ==========
  // Normal bottom padding for list content when no sticky bottom action
  static const double listBottomPadding = 20.0;

  // ========== Padding ==========
  static const double cardPadding = 16.0;
  static const double cardPaddingLarge = 20.0;
  static const double buttonPaddingHorizontal = 24.0;
  static const double iconBoxPadding = 12.0;

  // ========== Typography ==========
  static const double titleFontSize = 26.0;
  static const double largeTitleFontSize = 22.0;
  static const double sectionTitleFontSize = 18.0;
  static const double cardTitleFontSize = 17.0;
  static const double bodyFontSize = 14.0;
  static const double captionFontSize = 12.0;
  static const double smallCaptionFontSize = 11.0;

  // ========== Font Weights ==========
  static const fw.FontWeight extraBold = fw.FontWeight.w800;
  static const fw.FontWeight bold = fw.FontWeight.w700;
  static const fw.FontWeight semiBold = fw.FontWeight.w600;
  static const fw.FontWeight medium = fw.FontWeight.w500;
  static const fw.FontWeight regular = fw.FontWeight.w400;

  // ========== Letter Spacing ==========
  static const double titleLetterSpacing = -0.5;
  static const double headingLetterSpacing = -0.2;
  static const double bodyLetterSpacing = 0.1;
  static const double captionLetterSpacing = 0.0;

  // ========== Shadows ==========
  // Dark UI: depth comes from hairlines; shadows stay soft and black.
  static List<fw.BoxShadow> cardShadow(fw.Color color) => [
    fw.BoxShadow(
      color: isDark ? const fw.Color(0x73000000) : const fw.Color(0x1F3C3CA0),
      blurRadius: 34,
      offset: const fw.Offset(0, 12),
    ),
  ];

  static List<fw.BoxShadow> buttonShadow(fw.Color color) => [
    fw.BoxShadow(
      color: color.withValues(alpha: 0.42),
      blurRadius: 30,
      offset: const fw.Offset(0, 12),
    ),
  ];

  static List<fw.BoxShadow> iconBoxShadow(fw.Color color) => const [];

  // ========== Motion ==========
  static const Duration motionFast = Duration(milliseconds: 180);
  static const Duration motionBase = Duration(milliseconds: 320);
  static const Duration motionEntrance = Duration(milliseconds: 650);
  static const Duration motionStagger = Duration(milliseconds: 55);
  static const fw.Curve easeOut = fw.Cubic(0.2, 0.8, 0.2, 1.0);
  static const fw.Curve easeSpring = fw.Cubic(0.3, 1.2, 0.4, 1.0);

  // ========== Theme mode ==========
  /// Set by the app root (see ThemeController). Colors below follow it.
  /// Aurora: dark and light palettes.
  static bool isDark = true;

  static fw.Color _c(int dark, int light) =>
      fw.Color(isDark ? dark : light);

  // ========== Surfaces (glass) ==========
  static fw.Color get glassTop => _c(0xFF191C3D, 0xFFFFFFFF);
  static fw.Color get glassBottom => _c(0xFF12142B, 0xFFF6F7FF);
  static fw.Color get glassBorder =>
      isDark ? const fw.Color(0x1CFFFFFF) : const fw.Color(0xE6FFFFFF);
  static fw.Color get hairline =>
      isDark ? const fw.Color(0x12FFFFFF) : const fw.Color(0x12161733);
  static fw.Color get hairlineStrong =>
      isDark ? const fw.Color(0x21FFFFFF) : const fw.Color(0x21161733);

  /// Standard glass-card gradient used by cards and tiles.
  static fw.LinearGradient get glassGradient => fw.LinearGradient(
    begin: fw.Alignment.topCenter,
    end: fw.Alignment.bottomCenter,
    colors: [glassTop, glassBottom],
  );

  /// Brand gradient (violet -> blue) used by primary buttons and highlights.
  static const fw.Color gradientStart = fw.Color(0xFF7C5CFF);
  static const fw.Color gradientEnd = fw.Color(0xFF3DA9FC);
  static const fw.LinearGradient primaryGradient = fw.LinearGradient(
    begin: fw.Alignment.topRight,
    end: fw.Alignment.bottomLeft,
    colors: [gradientStart, gradientEnd],
  );
  static const List<fw.BoxShadow> glowShadow = [
    fw.BoxShadow(
      color: fw.Color(0x6B5C7CFF),
      blurRadius: 30,
      offset: fw.Offset(0, 12),
    ),
  ];

  /// Glass card decoration: gradient surface + glass hairline + soft shadow.
  static fw.BoxDecoration glassDecoration({double? radius, bool shadow = true}) =>
      fw.BoxDecoration(
        gradient: glassGradient,
        borderRadius: fw.BorderRadius.circular(radius ?? cardRadius),
        border: fw.Border.all(color: glassBorder, width: 1),
        boxShadow: shadow ? cardShadow(titleTextColor) : null,
      );

  // ========== Semantic Color Tokens ==========
  // Aurora palettes (dark + light).
  // Use these tokens, never raw hex. They are getters, so they cannot be
  // used inside `const` expressions.

  // Accent (brand)
  static fw.Color get primaryColor => _c(0xFF8F8CFF, 0xFF5B5BF0);
  static fw.Color get primarySoftColor => _c(0x298F8CFF, 0x1F5B5BF0);
  static fw.Color get accentColor => primaryColor;
  static fw.Color get accentSecondaryColor => _c(0xFF6FB6FF, 0xFF3DA9FC);
  static fw.Color get onAccentColor => _c(0xFF0A0B1E, 0xFFFFFFFF);

  // Success
  static fw.Color get successColor => _c(0xFF4FD1A0, 0xFF1F9D6B);
  static fw.Color get successSoftColor => _c(0x264FD1A0, 0xFFDDF3EA);

  // Warning
  static fw.Color get warningColor => _c(0xFFF2B25C, 0xFFC97712);
  static fw.Color get warningSoftColor => _c(0x26F2B25C, 0xFFFCEBD3);

  // Danger
  static fw.Color get dangerColor => _c(0xFFFF7A7F, 0xFFE5484D);
  static fw.Color get dangerSoftColor => _c(0x26FF7A7F, 0xFFFDE3E4);

  // Info
  static fw.Color get infoColor => _c(0xFF6FB0FF, 0xFF2D7FD9);
  static fw.Color get infoSoftColor => _c(0x266FB0FF, 0xFFE3EEFB);

  // Surfaces
  static fw.Color get backgroundColor => _c(0xFF080A1A, 0xFFECEEFF);
  static fw.Color get cardColor => _c(0xFF12142B, 0xFFFFFFFF);
  static fw.Color get surfaceColor => backgroundColor;
  static fw.Color get mutedSurfaceColor => _c(0xFF1B1E3D, 0xFFE1E4FA);
  static fw.Color get surface3Color => _c(0xFF343862, 0xFFC9CEF0);
  static fw.Color get navBackgroundColor => _c(0xFF1B1E3D, 0xFF161733);
  static fw.Color get navMutedColor => _c(0xFF9A9DC8, 0xFF9FA2C4);

  // Borders
  static fw.Color get borderColor => hairline;
  static fw.Color get mutedBorderColor =>
      isDark ? const fw.Color(0x0AFFFFFF) : const fw.Color(0x0D161733);

  // Text
  static fw.Color get titleTextColor => _c(0xFFF1F2FF, 0xFF161733);
  static fw.Color get mutedTextColor => _c(0xFF9A9DC8, 0xFF6A6D91);
  static fw.Color get placeholderTextColor => _c(0xFF6A6E9C, 0xFF9FA2C4);

  // ========== Status Colors ==========
  // Legacy status colors (kept for backward compatibility)
  static fw.Color get activeColor => successColor;
  static fw.Color get inactiveColor => dangerColor;
  static fw.Color get errorColor => dangerColor;
}
