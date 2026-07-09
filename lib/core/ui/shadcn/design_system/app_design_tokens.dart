import 'package:flutter/widgets.dart' as fw;

/// Design tokens for consistent UI across the app
/// Follow shadcn design principles: clean, minimal, professional
class AppDesignTokens {
  // ========== Spacing ==========
  static const double screenPaddingHorizontal = 16.0;
  static const double sectionGap = 20.0;
  static const double cardGap = 16.0;
  static const double itemGap = 12.0;
  static const double smallGap = 8.0;
  static const double tinyGap = 4.0;

  // ========== Border Radius ==========
  static const double cardRadius = 18.0;
  static const double buttonRadius = 14.0;
  static const double inputRadius = 12.0;
  static const double badgeRadius = 8.0;
  static const double iconBoxRadius = 12.0;

  // ========== Component Heights ==========
  static const double inputHeight = 48.0;
  static const double primaryButtonHeight = 52.0;
  static const double secondaryButtonHeight = 44.0;
  static const double iconBoxSize = 48.0;
  static const double iconBoxSmall = 44.0;
  static const double headerActionButtonSize = 40.0;

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
  static const double titleLetterSpacing = -0.8;
  static const double headingLetterSpacing = -0.4;
  static const double bodyLetterSpacing = 0.1;
  static const double captionLetterSpacing = 0.3;

  // ========== Shadows ==========
  static List<fw.BoxShadow> cardShadow(fw.Color color) => [
    fw.BoxShadow(
      color: color.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const fw.Offset(0, 2),
    ),
  ];

  static List<fw.BoxShadow> buttonShadow(fw.Color color) => [
    fw.BoxShadow(
      color: color.withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const fw.Offset(0, 4),
    ),
  ];

  static List<fw.BoxShadow> iconBoxShadow(fw.Color color) => [
    fw.BoxShadow(
      color: color.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const fw.Offset(0, 4),
    ),
  ];

  // ========== Semantic Color Tokens ==========
  // Clean, minimal color system following shadcn principles
  // Use these tokens for consistent coloring across the app

  // Primary colors
  static const primaryColor = fw.Color(0xFF3B82F6);
  static const primarySoftColor = fw.Color(0xFFDEEBFF);

  // Success colors (for active states, confirmations)
  static const successColor = fw.Color(0xFF10B981);
  static const successSoftColor = fw.Color(0xFFD1FAE5);

  // Warning colors (for caution states, unpaid)
  static const warningColor = fw.Color(0xFFF59E0B);
  static const warningSoftColor = fw.Color(0xFFFEF3C7);

  // Danger colors (for inactive, errors, out of stock)
  static const dangerColor = fw.Color(0xFFEF4444);
  static const dangerSoftColor = fw.Color(0xFFFEE2E2);

  // Info colors (for draft, neutral states)
  static const infoColor = fw.Color(0xFF06B6D4);
  static const infoSoftColor = fw.Color(0xFFCFFAFE);

  // Surface colors for backgrounds and containers
  static const surfaceColor = fw.Color(0xFFF8FAFC);
  static const mutedSurfaceColor = fw.Color(0xFFF1F5F9);

  // Border colors
  static const borderColor = fw.Color(0xFFE2E8F0);
  static const mutedBorderColor = fw.Color(0xFFF1F5F9);

  // Text colors
  static const titleTextColor = fw.Color(0xFF0F172A);
  static const mutedTextColor = fw.Color(0xFF64748B);
  static const placeholderTextColor = fw.Color(0xFF94A3B8);

  // ========== Status Colors ==========
  // Legacy status colors (kept for backward compatibility)
  static const activeColor = successColor;
  static const inactiveColor = dangerColor;
  static const errorColor = dangerColor;
}
