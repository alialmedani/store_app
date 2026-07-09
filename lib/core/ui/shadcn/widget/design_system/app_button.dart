import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';

/// Consistent button styles across the app
/// Provides primary, secondary, outlined, and destructive variants
/// Note: For most cases, use shadcn PrimaryButton, SecondaryButton, etc.
/// This widget is for custom sizing or special requirements.
class AppButton extends fw.StatelessWidget {
  final String text;
  final fw.VoidCallback? onPressed;
  final AppButtonVariant variant;
  final fw.Widget? leading;
  final fw.Widget? trailing;
  final double? height;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leading,
    this.trailing,
    this.height,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    // Get colors based on variant
    final colors = _getColors(theme, isDisabled);

    return fw.GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: fw.Container(
        height: height ?? AppDesignTokens.primaryButtonHeight,
        width: isFullWidth ? double.infinity : null,
        padding: const fw.EdgeInsets.symmetric(
          horizontal: AppDesignTokens.buttonPaddingHorizontal,
        ),
        decoration: fw.BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: fw.BorderRadius.circular(AppDesignTokens.buttonRadius),
          border: colors.borderColor != null
              ? fw.Border.all(color: colors.borderColor!, width: 1)
              : null,
          boxShadow: isDisabled
              ? null
              : AppDesignTokens.buttonShadow(colors.backgroundColor),
        ),
        child: fw.Row(
          mainAxisSize: isFullWidth ? fw.MainAxisSize.max : fw.MainAxisSize.min,
          mainAxisAlignment: fw.MainAxisAlignment.center,
          children: [
            if (leading != null && !isLoading) ...[
              leading!,
              const fw.SizedBox(width: AppDesignTokens.smallGap),
            ],
            if (isLoading) ...[
              fw.SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const fw.SizedBox(width: AppDesignTokens.smallGap),
            ],
            fw.Text(
              text,
              style: fw.TextStyle(
                fontSize: 15,
                fontWeight: AppDesignTokens.semiBold,
                color: colors.textColor,
              ),
            ),
            if (trailing != null && !isLoading) ...[
              const fw.SizedBox(width: AppDesignTokens.smallGap),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }

  _ButtonColors _getColors(ThemeData theme, bool isDisabled) {
    if (isDisabled) {
      return _ButtonColors(
        backgroundColor: theme.colorScheme.muted.withValues(alpha: 0.3),
        textColor: theme.colorScheme.mutedForeground,
      );
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return _ButtonColors(
          backgroundColor: theme.colorScheme.primary,
          textColor: theme.colorScheme.primaryForeground,
        );
      case AppButtonVariant.secondary:
        return _ButtonColors(
          backgroundColor: theme.colorScheme.secondary,
          textColor: theme.colorScheme.secondaryForeground,
        );
      case AppButtonVariant.outlined:
        return _ButtonColors(
          backgroundColor: fw.Color(0x00000000), // Transparent
          textColor: theme.colorScheme.foreground,
          borderColor: theme.colorScheme.border,
        );
      case AppButtonVariant.destructive:
        return _ButtonColors(
          backgroundColor: theme.colorScheme.destructive,
          textColor: theme.colorScheme.destructiveForeground,
        );
      case AppButtonVariant.ghost:
        return _ButtonColors(
          backgroundColor: theme.colorScheme.muted.withValues(alpha: 0.1),
          textColor: theme.colorScheme.foreground,
        );
    }
  }
}

enum AppButtonVariant { primary, secondary, outlined, destructive, ghost }

class _ButtonColors {
  final fw.Color backgroundColor;
  final fw.Color textColor;
  final fw.Color? borderColor;

  _ButtonColors({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
  });
}
