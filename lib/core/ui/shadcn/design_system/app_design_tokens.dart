import 'package:flutter/widgets.dart' as fw;

/// Design tokens for consistent UI across the app
/// Soft Bento design (light + dark): big rounded cards with soft shadows,
/// pill buttons, pastel tinted icon tiles, one accent, restrained motion.
class AppDesignTokens {
  // ========== Spacing ==========
  static const double screenPaddingHorizontal = 16.0;
  static const double sectionGap = 20.0;
  static const double cardGap = 16.0;
  static const double itemGap = 12.0;
  static const double smallGap = 8.0;
  static const double tinyGap = 4.0;

  // ========== Border Radius ==========
  static const double cardRadius = 26.0;
  static const double buttonRadius = 99.0;
  static const double inputRadius = 18.0;
  static const double badgeRadius = 12.0;
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
      color: isDark ? const fw.Color(0x52000000) : const fw.Color(0x121B1A17),
      blurRadius: 28,
      offset: const fw.Offset(0, 8),
    ),
  ];

  static List<fw.BoxShadow> buttonShadow(fw.Color color) => [
    fw.BoxShadow(
      color: color.withValues(alpha: 0.28),
      blurRadius: 18,
      offset: const fw.Offset(0, 6),
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
  /// Soft Bento: dark and light palettes.
  static bool isDark = true;

  static fw.Color _c(int dark, int light) =>
      fw.Color(isDark ? dark : light);

  // ========== Surfaces (glass) ==========
  // Soft Bento: cards are flat (no glass gradient).
  static fw.Color get glassTop => cardColor;
  static fw.Color get glassBottom => cardColor;
  static fw.Color get hairline =>
      isDark ? const fw.Color(0x12FFFFFF) : const fw.Color(0x141B1A17);
  static fw.Color get hairlineStrong =>
      isDark ? const fw.Color(0x21FFFFFF) : const fw.Color(0x241B1A17);

  /// Standard glass-card gradient used by cards and tiles.
  static fw.LinearGradient get glassGradient => fw.LinearGradient(
    begin: fw.Alignment.topCenter,
    end: fw.Alignment.bottomCenter,
    colors: [glassTop, glassBottom],
  );

  // ========== Semantic Color Tokens ==========
  // Soft Bento palettes (dark + light).
  // Use these tokens, never raw hex. They are getters, so they cannot be
  // used inside `const` expressions.

  // Accent (brand)
  static fw.Color get primaryColor => _c(0xFF8B8CFF, 0xFF4F46E5);
  static fw.Color get primarySoftColor => _c(0x298B8CFF, 0xFFE9E8FD);
  static fw.Color get accentColor => primaryColor;
  static fw.Color get accentSecondaryColor => _c(0xFFB79CFF, 0xFF7C5CFF);
  static fw.Color get onAccentColor => _c(0xFF0F1013, 0xFFFFFFFF);

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
  static fw.Color get backgroundColor => _c(0xFF0F1013, 0xFFF4F1EC);
  static fw.Color get cardColor => _c(0xFF191B20, 0xFFFFFFFF);
  static fw.Color get surfaceColor => backgroundColor;
  static fw.Color get mutedSurfaceColor => _c(0xFF22252B, 0xFFEFEBE4);
  static fw.Color get surface3Color => _c(0xFF3A3E47, 0xFFD9D4CA);
  static fw.Color get navBackgroundColor => _c(0xFF22252B, 0xFF1B1A17);
  static fw.Color get navMutedColor => _c(0xFF9A9CA5, 0xFFA8A398);

  // Borders
  static fw.Color get borderColor => hairline;
  static fw.Color get mutedBorderColor =>
      isDark ? const fw.Color(0x0AFFFFFF) : const fw.Color(0x0D1B1A17);

  // Text
  static fw.Color get titleTextColor => _c(0xFFF3F2EE, 0xFF1B1A17);
  static fw.Color get mutedTextColor => _c(0xFF9A9CA5, 0xFF7C786F);
  static fw.Color get placeholderTextColor => _c(0xFF656873, 0xFFA8A398);

  // ========== Status Colors ==========
  // Legacy status colors (kept for backward compatibility)
  static fw.Color get activeColor => successColor;
  static fw.Color get inactiveColor => dangerColor;
  static fw.Color get errorColor => dangerColor;
}
