import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';

/// Unified card style for consistent appearance
/// Base component for all card-based UI elements
class AppCard extends fw.StatelessWidget {
  final fw.Widget child;
  final fw.VoidCallback? onTap;
  final fw.EdgeInsetsGeometry? padding;
  final fw.Color? borderColor;
  final fw.Color? backgroundColor;
  final List<fw.BoxShadow>? boxShadow;
  final double? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderColor,
    this.backgroundColor,
    this.boxShadow,
    this.borderRadius,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    final card = fw.Container(
      padding: padding ?? const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
      decoration: fw.BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.card,
        borderRadius: fw.BorderRadius.circular(
          borderRadius ?? AppDesignTokens.cardRadius,
        ),
        border: fw.Border.all(
          color: borderColor ?? theme.colorScheme.border.withOpacity(0.5),
          width: 1,
        ),
        boxShadow:
            boxShadow ??
            AppDesignTokens.cardShadow(theme.colorScheme.foreground),
      ),
      child: child,
    );

    if (onTap != null) {
      return fw.GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}

/// Stat card for dashboard statistics
/// Shows icon, title, value, and optional subtitle
class StatCard extends fw.StatelessWidget {
  final fw.IconData icon;
  final String title;
  final String value;
  final fw.Color color;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.subtitle,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      borderColor: color.withOpacity(0.15),
      boxShadow: AppDesignTokens.iconBoxShadow(color),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          // Icon box
          fw.Container(
            padding: const fw.EdgeInsets.all(AppDesignTokens.iconBoxPadding),
            decoration: fw.BoxDecoration(
              gradient: fw.LinearGradient(
                begin: fw.Alignment.topLeft,
                end: fw.Alignment.bottomRight,
                colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
              ),
              borderRadius: fw.BorderRadius.circular(
                AppDesignTokens.iconBoxRadius,
              ),
              border: fw.Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: fw.Icon(icon, size: 24, color: color),
          ),
          const fw.SizedBox(height: AppDesignTokens.sectionGap - 2),
          // Title
          fw.Text(
            title,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.captionFontSize + 1,
              fontWeight: AppDesignTokens.semiBold,
              color: theme.colorScheme.mutedForeground,
              letterSpacing: AppDesignTokens.captionLetterSpacing,
            ),
          ),
          const fw.SizedBox(height: AppDesignTokens.smallGap),
          // Value
          fw.Text(
            value,
            style: const fw.TextStyle(
              fontSize: 30,
              fontWeight: AppDesignTokens.extraBold,
              letterSpacing: AppDesignTokens.titleLetterSpacing,
              height: 1,
            ),
          ),
          if (subtitle != null) ...[
            const fw.SizedBox(height: AppDesignTokens.smallGap - 2),
            fw.Text(
              subtitle!,
              style: fw.TextStyle(
                fontSize: AppDesignTokens.captionFontSize,
                fontWeight: AppDesignTokens.medium,
                color: theme.colorScheme.mutedForeground,
                letterSpacing: AppDesignTokens.bodyLetterSpacing,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Menu tile for main navigation items
/// Shows icon, title, subtitle with gradient styling
class MenuTile extends fw.StatelessWidget {
  final fw.IconData icon;
  final String title;
  final String subtitle;
  final fw.Color color;
  final fw.VoidCallback onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      borderColor: color.withOpacity(0.12),
      boxShadow: AppDesignTokens.iconBoxShadow(color),
      padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        mainAxisSize: fw.MainAxisSize.min,
        children: [
          // Icon box
          fw.Container(
            padding: const fw.EdgeInsets.all(AppDesignTokens.iconBoxPadding),
            decoration: fw.BoxDecoration(
              gradient: fw.LinearGradient(
                begin: fw.Alignment.topLeft,
                end: fw.Alignment.bottomRight,
                colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
              ),
              borderRadius: fw.BorderRadius.circular(
                AppDesignTokens.iconBoxRadius,
              ),
              border: fw.Border.all(color: color.withOpacity(0.25), width: 1),
            ),
            child: fw.Icon(icon, size: 26, color: color),
          ),
          const fw.SizedBox(height: 18),
          // Text content
          fw.Text(
            title,
            style: const fw.TextStyle(
              fontSize: AppDesignTokens.cardTitleFontSize - 1,
              fontWeight: AppDesignTokens.bold,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          const fw.SizedBox(height: AppDesignTokens.tinyGap),
          fw.Text(
            subtitle,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.captionFontSize,
              fontWeight: AppDesignTokens.medium,
              color: theme.colorScheme.mutedForeground,
              letterSpacing: AppDesignTokens.bodyLetterSpacing,
            ),
          ),
        ],
      ),
    );
  }
}
