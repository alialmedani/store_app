import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';

/// Empty state widget for when there's no data to display
/// Shows icon, title, subtitle, and optional action button
class EmptyState extends fw.StatelessWidget {
  final fw.IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final fw.VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Center(
      child: fw.Padding(
        padding: const fw.EdgeInsets.all(AppDesignTokens.cardPaddingLarge * 2),
        child: fw.Column(
          mainAxisAlignment: fw.MainAxisAlignment.center,
          children: [
            // Icon
            fw.Container(
              padding: const fw.EdgeInsets.all(
                AppDesignTokens.iconBoxPadding * 2,
              ),
              decoration: fw.BoxDecoration(
                color: theme.colorScheme.muted.withValues(alpha: 0.3),
                borderRadius: fw.BorderRadius.circular(
                  AppDesignTokens.cardRadius,
                ),
                border: fw.Border.all(
                  color: theme.colorScheme.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: fw.Icon(
                icon,
                size: 64,
                color: theme.colorScheme.mutedForeground.withValues(alpha: 0.5),
              ),
            ),
            const fw.SizedBox(height: AppDesignTokens.sectionGap + 4),
            // Title
            fw.Text(
              title,
              textAlign: fw.TextAlign.center,
              style: fw.TextStyle(
                fontSize: AppDesignTokens.sectionTitleFontSize,
                fontWeight: AppDesignTokens.bold,
                color: theme.colorScheme.foreground,
                letterSpacing: AppDesignTokens.headingLetterSpacing,
              ),
            ),
            const fw.SizedBox(height: AppDesignTokens.smallGap),
            // Subtitle
            fw.Text(
              subtitle,
              textAlign: fw.TextAlign.center,
              style: fw.TextStyle(
                fontSize: AppDesignTokens.bodyFontSize,
                fontWeight: AppDesignTokens.medium,
                color: theme.colorScheme.mutedForeground,
                letterSpacing: AppDesignTokens.bodyLetterSpacing,
                height: 1.5,
              ),
            ),
            // Optional button
            if (buttonText != null && onButtonPressed != null) ...[
              const fw.SizedBox(height: AppDesignTokens.sectionGap + 4),
              PrimaryButton(
                onPressed: onButtonPressed,
                child: fw.Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
