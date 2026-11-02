import 'package:flutter/widgets.dart' as fw;
import 'package:store/core/ui/kit/app_kit.dart';
import '../../design_system/app_design_tokens.dart';

/// Section heading used on every details screen: gradient bar + title
class AppSectionTitle extends fw.StatelessWidget {
  final String title;
  final fw.Widget? trailing;
  const AppSectionTitle(this.title, {super.key, this.trailing});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      children: [
        fw.Container(
          width: 4,
          height: 18,
          decoration: fw.BoxDecoration(
            gradient: AppDesignTokens.primaryGradient,
            borderRadius: fw.BorderRadius.circular(2),
          ),
        ),
        const fw.SizedBox(width: 10),
        fw.Expanded(
          child: fw.Text(
            title,
            style: fw.TextStyle(
              fontSize: 17,
              fontWeight: AppDesignTokens.bold,
              letterSpacing: -0.2,
              color: AppDesignTokens.titleTextColor,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Glass card holding [AppInfoRow]s separated by hairlines
class AppInfoSection extends fw.StatelessWidget {
  final List<fw.Widget> children;
  const AppInfoSection({super.key, required this.children});

  @override
  fw.Widget build(fw.BuildContext context) {
    final items = <fw.Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        items.add(
          fw.Container(
            height: 1,
            margin: const fw.EdgeInsets.symmetric(horizontal: 16),
            color: AppDesignTokens.borderColor.withValues(alpha: 0.5),
          ),
        );
      }
      items.add(children[i]);
    }
    return fw.Container(
      width: double.infinity,
      decoration: AppDesignTokens.glassDecoration(),
      child: fw.Column(children: items),
    );
  }
}

/// One row: tinted icon tile + label (muted) + value
class AppInfoRow extends fw.StatelessWidget {
  final fw.IconData icon;
  final String label;
  final String value;
  final fw.Color? valueColor;
  const AppInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final primary = AppDesignTokens.primaryColor;
    return fw.Padding(
      padding: const fw.EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: fw.Row(
        children: [
          fw.Container(
            width: 38,
            height: 38,
            decoration: fw.BoxDecoration(
              color: primary.withValues(alpha: 0.14),
              borderRadius: fw.BorderRadius.circular(12),
            ),
            child: fw.Icon(icon, size: 19, color: primary),
          ),
          const fw.SizedBox(width: 12),
          fw.Expanded(
            child: fw.Text(
              label,
              style: fw.TextStyle(
                fontSize: 13.5,
                fontWeight: AppDesignTokens.medium,
                color: AppDesignTokens.mutedTextColor,
              ),
            ),
          ),
          const fw.SizedBox(width: 8),
          fw.Flexible(
            child: fw.Text(
              value,
              textAlign: fw.TextAlign.end,
              maxLines: 2,
              overflow: fw.TextOverflow.ellipsis,
              style: fw.TextStyle(
                fontSize: 14.5,
                fontWeight: AppDesignTokens.bold,
                color: valueColor ?? AppDesignTokens.titleTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small stat tile (value over label). [highlight] paints it with the Aurora gradient.
class AppStatTile extends fw.StatelessWidget {
  final String label;
  final String value;
  final fw.IconData? icon;
  final bool highlight;
  const AppStatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.highlight = false,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final fg = highlight
        ? const fw.Color(0xFFFFFFFF)
        : AppDesignTokens.titleTextColor;
    final sub = highlight
        ? const fw.Color(0xFFFFFFFF).withValues(alpha: 0.8)
        : AppDesignTokens.mutedTextColor;
    return fw.Container(
      padding: const fw.EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: highlight
          ? fw.BoxDecoration(
              gradient: AppDesignTokens.primaryGradient,
              borderRadius: fw.BorderRadius.circular(
                AppDesignTokens.cardRadius - 4,
              ),
              boxShadow: AppDesignTokens.glowShadow,
            )
          : AppDesignTokens.glassDecoration(
              radius: AppDesignTokens.cardRadius - 4,
            ),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            fw.Icon(
              icon,
              size: 18,
              color: highlight ? fg : AppDesignTokens.primaryColor,
            ),
            const fw.SizedBox(height: 8),
          ],
          fw.Text(
            value,
            maxLines: 1,
            overflow: fw.TextOverflow.ellipsis,
            style: fw.TextStyle(
              fontSize: 20,
              fontWeight: AppDesignTokens.extraBold,
              color: fg,
            ),
          ),
          const fw.SizedBox(height: 2),
          fw.Text(
            label,
            maxLines: 1,
            overflow: fw.TextOverflow.ellipsis,
            style: fw.TextStyle(fontSize: 12, color: sub),
          ),
        ],
      ),
    );
  }
}

/// Large title block used at the top of the bottom-nav tabs
class AppTabHeader extends fw.StatelessWidget {
  final String title;
  final String subtitle;
  final fw.IconData icon;
  const AppTabHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Padding(
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.screenPaddingHorizontal + 8,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.sectionGap,
      ),
      child: fw.Row(
        children: [
          fw.Expanded(
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                fw.Text(
                  title,
                  style: fw.TextStyle(
                    fontSize: 28,
                    fontWeight: AppDesignTokens.extraBold,
                    letterSpacing: -0.5,
                    height: 1.1,
                    color: AppDesignTokens.titleTextColor,
                  ),
                ),
                const fw.SizedBox(height: 4),
                fw.Text(
                  subtitle,
                  style: fw.TextStyle(
                    fontSize: 14,
                    color: AppDesignTokens.mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
          const fw.SizedBox(width: 12),
          fw.Container(
            width: 48,
            height: 48,
            decoration: fw.BoxDecoration(
              gradient: AppDesignTokens.primaryGradient,
              borderRadius: fw.BorderRadius.circular(
                AppDesignTokens.iconBoxRadius,
              ),
              boxShadow: AppDesignTokens.glowShadow,
            ),
            child: fw.Icon(icon, size: 24, color: const fw.Color(0xFFFFFFFF)),
          ),
        ],
      ),
    );
  }
}

/// Big glass circle with an icon, used for empty / coming-soon states
class AppHeroIcon extends fw.StatelessWidget {
  final fw.IconData icon;
  const AppHeroIcon(this.icon, {super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      width: 112,
      height: 112,
      decoration: fw.BoxDecoration(
        gradient: AppDesignTokens.glassGradient,
        shape: fw.BoxShape.circle,
        border: fw.Border.all(color: AppDesignTokens.glassBorder),
        boxShadow: AppDesignTokens.glowShadow,
      ),
      child: fw.Center(
        child: fw.ShaderMask(
          shaderCallback: (r) =>
              AppDesignTokens.primaryGradient.createShader(r),
          child: fw.Icon(icon, size: 52, color: const fw.Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
