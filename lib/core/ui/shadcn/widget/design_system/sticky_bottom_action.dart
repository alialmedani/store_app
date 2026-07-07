import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';

/// Sticky bottom action button with safe area padding
/// Floats above content with shadow for visual separation
class StickyBottomAction extends fw.StatelessWidget {
  final fw.Widget child;
  final fw.EdgeInsetsGeometry? padding;

  const StickyBottomAction({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Positioned(
      left: AppDesignTokens.screenPaddingHorizontal,
      right: AppDesignTokens.screenPaddingHorizontal,
      bottom: AppDesignTokens.screenPaddingHorizontal,
      child: fw.Container(
        decoration: fw.BoxDecoration(
          boxShadow: AppDesignTokens.buttonShadow(
            theme.colorScheme.foreground,
          ),
        ),
        child: fw.Padding(
          padding: padding ?? fw.EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
