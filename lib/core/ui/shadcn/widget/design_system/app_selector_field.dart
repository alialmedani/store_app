import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';

/// Reusable selector field that looks like an input but opens a picker/selector
/// Used for categories, products, dropdowns, etc.
class AppSelectorField extends fw.StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final fw.VoidCallback onTap;
  final String? actionText;
  final String? errorText;
  final bool enabled;
  final bool showRequired;

  const AppSelectorField({
    super.key,
    required this.label,
    this.value,
    required this.placeholder,
    required this.onTap,
    this.actionText,
    this.errorText,
    this.enabled = true,
    this.showRequired = false,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        // Label row with optional action text
        fw.Row(
          children: [
            fw.Expanded(
              child: fw.Row(
                children: [
                  fw.Text(
                    label,
                    style: fw.TextStyle(
                      fontSize: AppDesignTokens.bodyFontSize,
                      fontWeight: AppDesignTokens.semiBold,
                      color: AppDesignTokens.titleTextColor,
                    ),
                  ),
                  if (showRequired) ...[
                    const fw.SizedBox(width: 4),
                    fw.Text(
                      '*',
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.bodyFontSize,
                        fontWeight: AppDesignTokens.semiBold,
                        color: AppDesignTokens.dangerColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (actionText != null)
              fw.GestureDetector(
                onTap: enabled ? onTap : null,
                child: fw.Text(
                  actionText!,
                  style: fw.TextStyle(
                    fontSize: AppDesignTokens.bodyFontSize,
                    fontWeight: AppDesignTokens.semiBold,
                    color: enabled
                        ? theme.colorScheme.primary
                        : AppDesignTokens.mutedTextColor,
                  ),
                ),
              ),
          ],
        ),
        const fw.SizedBox(height: AppDesignTokens.smallGap),

        // Selector field (clickable container that looks like input)
        fw.GestureDetector(
          onTap: enabled ? onTap : null,
          child: fw.Container(
            height: AppDesignTokens.inputHeight,
            padding: const fw.EdgeInsets.symmetric(
              horizontal: AppDesignTokens.cardPadding,
            ),
            decoration: fw.BoxDecoration(
              color: enabled
                  ? theme.colorScheme.background
                  : AppDesignTokens.mutedSurfaceColor,
              borderRadius: fw.BorderRadius.circular(
                AppDesignTokens.inputRadius,
              ),
              border: fw.Border.all(
                color: errorText != null
                    ? AppDesignTokens.dangerColor
                    : theme.colorScheme.border,
                width: 1,
              ),
            ),
            child: fw.Row(
              children: [
                fw.Expanded(
                  child: fw.Text(
                    value ?? placeholder,
                    style: fw.TextStyle(
                      fontSize: AppDesignTokens.bodyFontSize,
                      color: value != null
                          ? theme.colorScheme.foreground
                          : AppDesignTokens.mutedTextColor,
                    ),
                  ),
                ),
                fw.Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: enabled
                      ? theme.colorScheme.mutedForeground
                      : AppDesignTokens.mutedTextColor,
                ),
              ],
            ),
          ),
        ),

        // Error text
        if (errorText != null)
          fw.Padding(
            padding: const fw.EdgeInsets.only(top: AppDesignTokens.tinyGap),
            child: fw.Text(
              errorText!,
              style: fw.TextStyle(
                color: AppDesignTokens.dangerColor,
                fontSize: AppDesignTokens.captionFontSize,
              ),
            ),
          ),
      ],
    );
  }
}
