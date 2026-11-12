import 'package:flutter/widgets.dart' as fw;

/// Design tokens for consistent UI across the app.
///
/// "Ink & Ember" design (light + dark): a near-monochrome editorial canvas with
/// ONE warm accent (Ember). Flat paper/ink cards with a hairline (Line) border
/// and a soft shadow (NOT glass gradients). Serif-italic display type for
/// promo/editorial headlines only; system sans for all UI chrome and body.
///
/// Palette (light): Ink #121212, Paper #FFFFFF, Mist #F4F4F2, Line #E7E6E2,
/// Ember #F2622A (deep #D94E1C), Blush #F2456B (promo tag only), Stone #8C8A86,
/// page background #EEECE7.
/// Palette (dark): ground #121212, card #1C1C1C, line #303030, text #EDECE8,
/// Ember unchanged (#F2622A). Ember is the single accent everywhere.
///
/// NOTE: the token names kept from the old "Aurora" system (glassDecoration,
/// glassGradient, primaryGradient, glowShadow, glassBorder ...) are REPURPOSED
/// to the flat Ember style so existing call sites keep working and stay
/// consistent. There is no glass/gradient surface anymore.
class AppDesignTokens {
  // ========== Spacing ==========
  static const double screenPaddingHorizontal = 16.0;
  static const double sectionGap = 20.0;
  static const double cardGap = 16.0;
  static const double itemGap = 12.0;
  static const double smallGap = 8.0;
  static const double tinyGap = 4.0;

  // ========== Border Radius ==========
  // Flatter, more editorial than Aurora: cards 16, tiles 12, inputs 12.
  static const double cardRadius = 16.0;
  static const double tileRadius = 12.0;
  static const double buttonRadius = 14.0;
  static const double inputRadius = 12.0;
  static const double badgeRadius = 8.0;
  static const double pillRadius = 99.0;
  static const double iconBoxRadius = 12.0;

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

  /// UI / body font (bundled). Used for every label, price, nav item, body.
  static const String fontFamily = 'IBMPlexSansArabic';

  /// Display font for promo/banner/editorial headlines ONLY (serif, italic).
  /// Georgia is not bundled; we fall back to the platform serif. Use with
  /// [fw.FontStyle.italic] and [displayFontFamilyFallback].
  static const String displayFontFamily = 'Georgia';
  static const List<String> displayFontFamilyFallback = <String>[
    'Times New Roman',
    'serif',
  ];

  // ========== Font Weights ==========
  static const fw.FontWeight extraBold = fw.FontWeight.w800;
  static const fw.FontWeight bold = fw.FontWeight.w700;
  static const fw.FontWeight semiBold = fw.FontWeight.w600;
  static const fw.FontWeight medium = fw.FontWeight.w500;
  static const fw.FontWeight regular = fw.FontWeight.w400;

  /// Tabular figures for prices and any aligned numbers.
  static const List<fw.FontFeature> tabularFigures = <fw.FontFeature>[
    fw.FontFeature.tabularFigures(),
  ];

  // ========== Letter Spacing ==========
  static const double titleLetterSpacing = -0.5;
  static const double headingLetterSpacing = -0.2;
  static const double bodyLetterSpacing = 0.1;
  static const double captionLetterSpacing = 0.0;
  // Loose tracking for the serif display headlines.
  static const double displayLetterSpacing = 0.3;

  // ========== Shadows ==========
  // Depth is soft and neutral; the design leans on hairlines, not glow.
  static List<fw.BoxShadow> cardShadow(fw.Color color) => [
    fw.BoxShadow(
      color: isDark ? const fw.Color(0x66000000) : const fw.Color(0x14121212),
      blurRadius: isDark ? 24 : 18,
      offset: const fw.Offset(0, 8),
    ),
  ];

  /// Stronger "lifted" shadow for cards that should read as elevated/floating
  /// (dashboard KPI cards, list rows, menu rows). One source of truth so every
  /// feature's elevated surfaces match.
  static List<fw.BoxShadow> elevatedShadow() => [
    fw.BoxShadow(
      color: isDark ? const fw.Color(0x80000000) : const fw.Color(0x1F121212),
      blurRadius: 28,
      offset: const fw.Offset(0, 14),
    ),
  ];

  static List<fw.BoxShadow> buttonShadow(fw.Color color) => [
    fw.BoxShadow(
      color: color.withValues(alpha: 0.24),
      blurRadius: 18,
      offset: const fw.Offset(0, 8),
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
  static bool isDark = false;

  static fw.Color _c(int dark, int light) =>
      fw.Color(isDark ? dark : light);

  // ========== Surfaces ==========
  // Flat paper/ink surfaces with a Line hairline. No gradients.
  static fw.Color get glassTop => cardColor;
  static fw.Color get glassBottom => cardColor;
  static fw.Color get glassBorder => _c(0xFF303030, 0xFFE7E6E2);
  static fw.Color get hairline => _c(0xFF303030, 0xFFE7E6E2);
  static fw.Color get hairlineStrong => _c(0xFF3A3A3A, 0xFFD9D8D3);

  /// Repurposed: a flat "gradient" (both stops = card surface) so legacy
  /// call sites render a solid paper/ink card.
  static fw.LinearGradient get glassGradient => fw.LinearGradient(
    begin: fw.Alignment.topCenter,
    end: fw.Alignment.bottomCenter,
    colors: [cardColor, cardColor],
  );

  // ========== Ember accent ==========
  static const fw.Color ember = fw.Color(0xFFF2622A);
  static const fw.Color emberDeep = fw.Color(0xFFD94E1C);
  static const fw.Color blush = fw.Color(0xFFF2456B);

  /// Brand "gradient" is now the single Ember accent (ember -> deep ember),
  /// subtle enough to read as a solid accent on buttons and CTAs.
  static const fw.Color gradientStart = ember;
  static const fw.Color gradientEnd = emberDeep;
  static const fw.LinearGradient primaryGradient = fw.LinearGradient(
    begin: fw.Alignment.topCenter,
    end: fw.Alignment.bottomCenter,
    colors: [ember, emberDeep],
  );

  /// Soft ember shadow for primary CTAs (restrained, not a glow).
  static const List<fw.BoxShadow> glowShadow = [
    fw.BoxShadow(
      color: fw.Color(0x38F2622A),
      blurRadius: 18,
      offset: fw.Offset(0, 8),
    ),
  ];

  /// Flat card decoration: solid surface + Line hairline + soft shadow.
  static fw.BoxDecoration glassDecoration({double? radius, bool shadow = true}) =>
      fw.BoxDecoration(
        color: cardColor,
        borderRadius: fw.BorderRadius.circular(radius ?? cardRadius),
        border: fw.Border.all(color: glassBorder, width: 1),
        boxShadow: shadow ? cardShadow(titleTextColor) : null,
      );

  // ========== Semantic Color Tokens ==========
  // Ink & Ember palettes (dark + light). Use these tokens, never raw hex.
  // They are getters, so they cannot be used inside `const` expressions.

  // Accent (brand) = Ember, one accent everywhere.
  static fw.Color get primaryColor => ember;
  static fw.Color get primarySoftColor => _c(0x29F2622A, 0x1FF2622A);
  static fw.Color get accentColor => primaryColor;
  static fw.Color get accentSecondaryColor => emberDeep;
  static fw.Color get onAccentColor => const fw.Color(0xFFFFFFFF);

  // Blush: promo/status tag ONLY (never a second button accent).
  static fw.Color get blushColor => blush;
  static fw.Color get blushSoftColor => _c(0x29F2456B, 0x1FF2456B);

  // Success
  static fw.Color get successColor => _c(0xFF4FD1A0, 0xFF1F9D6B);
  static fw.Color get successSoftColor => _c(0x264FD1A0, 0xFFDDF3EA);

  // Warning
  static fw.Color get warningColor => _c(0xFFF2B25C, 0xFFC9801A);
  static fw.Color get warningSoftColor => _c(0x26F2B25C, 0xFFFBEBD1);

  // Danger
  static fw.Color get dangerColor => _c(0xFFFF7A7F, 0xFFD64545);
  static fw.Color get dangerSoftColor => _c(0x26FF7A7F, 0xFFFBE2E2);

  // Info
  static fw.Color get infoColor => _c(0xFF6FB0FF, 0xFF3A6EA5);
  static fw.Color get infoSoftColor => _c(0x266FB0FF, 0xFFE4ECF5);

  // Surfaces
  static fw.Color get backgroundColor => _c(0xFF121212, 0xFFEEECE7);
  static fw.Color get cardColor => _c(0xFF1C1C1C, 0xFFFFFFFF);
  static fw.Color get surfaceColor => backgroundColor;
  static fw.Color get mutedSurfaceColor => _c(0xFF262626, 0xFFF4F4F2);
  static fw.Color get surface3Color => _c(0xFF303030, 0xFFE7E6E2);
  // Ink bottom-nav pill (dark ink in both themes, lifted in dark).
  static fw.Color get navBackgroundColor => _c(0xFF242424, 0xFF121212);
  static fw.Color get navMutedColor => _c(0xFF8C8A86, 0xFF8C8A86);

  // Borders
  static fw.Color get borderColor => hairline;
  static fw.Color get mutedBorderColor =>
      isDark ? const fw.Color(0xFF262626) : const fw.Color(0xFFEDECE8);

  // Text
  static fw.Color get titleTextColor => _c(0xFFEDECE8, 0xFF121212);
  static fw.Color get mutedTextColor => _c(0xFFA3A19C, 0xFF8C8A86);
  static fw.Color get placeholderTextColor => _c(0xFF6E6C68, 0xFFA8A6A2);

  // ========== Status Colors ==========
  // Legacy status colors (kept for backward compatibility)
  static fw.Color get activeColor => successColor;
  static fw.Color get inactiveColor => dangerColor;
  static fw.Color get errorColor => dangerColor;
}
