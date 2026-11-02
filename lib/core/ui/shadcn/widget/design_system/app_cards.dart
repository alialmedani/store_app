import 'package:flutter/widgets.dart' as fw;
import 'package:store/core/ui/kit/app_kit.dart';
import '../../design_system/app_design_tokens.dart';
import 'app_motion.dart';

/// Unified card (Aurora): glass gradient surface, glass hairline, soft shadow.
/// Tappable cards press-scale.
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
        color: backgroundColor,
        gradient: backgroundColor == null
            ? AppDesignTokens.glassGradient
            : null,
        borderRadius: fw.BorderRadius.circular(
          borderRadius ?? AppDesignTokens.cardRadius,
        ),
        border: fw.Border.all(
          color: borderColor ?? AppDesignTokens.glassBorder,
          width: 1,
        ),
        boxShadow:
            boxShadow ??
            AppDesignTokens.cardShadow(theme.colorScheme.foreground),
      ),
      child: child,
    );

    if (onTap != null) {
      return PressScale(onTap: onTap, child: card);
    }

    return card;
  }
}

/// Pastel tinted icon tile used by stat cards, menu tiles and rows.
class AppIconChip extends fw.StatelessWidget {
  final fw.IconData icon;
  final fw.Color color;
  final double size;

  const AppIconChip({
    super.key,
    required this.icon,
    required this.color,
    this.size = 22,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(AppDesignTokens.iconBoxPadding - 1),
      decoration: fw.BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: fw.BorderRadius.circular(AppDesignTokens.iconBoxRadius),
      ),
      child: fw.Icon(icon, size: size, color: color),
    );
  }
}

/// Stat card for dashboard statistics
/// Shows icon, title, value (counts up when numeric), and optional subtitle
class StatCard extends fw.StatelessWidget {
  final fw.IconData icon;
  final String title;
  final String value;
  final fw.Color color;
  final String? subtitle;
  final int animationIndex;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.subtitle,
    this.animationIndex = 0,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final numeric = num.tryParse(value);
    const valueStyle = fw.TextStyle(
      fontSize: 30,
      fontWeight: AppDesignTokens.bold,
      letterSpacing: AppDesignTokens.titleLetterSpacing,
      height: 1,
      fontFeatures: [fw.FontFeature.tabularFigures()],
    );

    return FadeSlideIn(
      index: animationIndex,
      child: AppCard(
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          fw.Row(
            mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
            children: [
              AppIconChip(icon: icon, color: color),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),
          fw.Text(
            title,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.captionFontSize + 1,
              fontWeight: AppDesignTokens.medium,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          const fw.SizedBox(height: AppDesignTokens.tinyGap + 2),
          if (numeric != null)
            CountUpText(value: numeric, style: valueStyle)
          else
            fw.Text(value, style: valueStyle),
          if (subtitle != null) ...[
            const fw.SizedBox(height: AppDesignTokens.smallGap - 2),
            fw.Text(
              subtitle!,
              style: fw.TextStyle(
                fontSize: AppDesignTokens.captionFontSize,
                fontWeight: AppDesignTokens.medium,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}

/// Menu tile for main navigation items
/// Shows icon, title, subtitle on a glass card
class MenuTile extends fw.StatelessWidget {
  final fw.IconData icon;
  final String title;
  final String subtitle;
  final fw.Color color;
  final fw.VoidCallback onTap;
  final int animationIndex;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.animationIndex = 0,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return FadeSlideIn(
      index: animationIndex,
      child: AppCard(
      onTap: onTap,
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        mainAxisSize: fw.MainAxisSize.min,
        children: [
          AppIconChip(icon: icon, color: color, size: 24),
          const fw.SizedBox(height: 18),
          fw.Text(
            title,
            style: const fw.TextStyle(
              fontSize: AppDesignTokens.cardTitleFontSize - 1,
              fontWeight: AppDesignTokens.semiBold,
              height: 1.2,
            ),
          ),
          const fw.SizedBox(height: AppDesignTokens.tinyGap),
          fw.Text(
            subtitle,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.captionFontSize,
              fontWeight: AppDesignTokens.regular,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
