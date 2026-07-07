import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';

/// Consistent text field style across the app
/// Wraps shadcn TextField with app-specific defaults
class AppTextField extends fw.StatelessWidget {
  final fw.TextEditingController? controller;
  final String? placeholder;
  final String? label;
  final String? errorText;
  final bool obscureText;
  final fw.TextInputType? keyboardType;
  final fw.ValueChanged<String>? onChanged;
  final fw.VoidCallback? onTap;
  final bool readOnly;
  final fw.Widget? suffix;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final bool enabled;

  const AppTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.label,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.suffix,
    this.maxLines = 1,
    this.minLines,
    this.height,
    this.enabled = true,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          fw.Text(
            label!,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.bodyFontSize,
              fontWeight: AppDesignTokens.semiBold,
              color: theme.colorScheme.foreground,
            ),
          ),
          const fw.SizedBox(height: AppDesignTokens.smallGap),
        ],
        fw.SizedBox(
          height: height ?? (maxLines == 1 ? AppDesignTokens.inputHeight : null),
          child: TextField(
            controller: controller,
            placeholder: placeholder != null ? Text(placeholder!) : null,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            readOnly: readOnly,
            maxLines: maxLines,
            minLines: minLines,
            enabled: enabled,
            style: const fw.TextStyle(
              fontSize: AppDesignTokens.bodyFontSize,
            ),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty) ...[
          const fw.SizedBox(height: AppDesignTokens.smallGap - 2),
          fw.Text(
            errorText!,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.captionFontSize,
              fontWeight: AppDesignTokens.medium,
              color: theme.colorScheme.destructive,
            ),
          ),
        ],
      ],
    );
  }
}
