import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';

/// Sticky bottom action button container
/// Use inside Column layout below Expanded scrollable content
class StickyBottomAction extends fw.StatelessWidget {
  final fw.Widget child;
  final fw.EdgeInsetsGeometry? padding;

  const StickyBottomAction({super.key, required this.child, this.padding});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Container(
      padding:
          padding ??
          const fw.EdgeInsets.all(AppDesignTokens.screenPaddingHorizontal),
      decoration: fw.BoxDecoration(
        color: theme.colorScheme.background,
        border: fw.Border(
          top: fw.BorderSide(
            color: theme.colorScheme.border.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          fw.BoxShadow(
            color: theme.colorScheme.foreground.withOpacity(0.05),
            blurRadius: 10,
            offset: const fw.Offset(0, -2),
          ),
        ],
      ),
      child: fw.SafeArea(top: false, child: child),
    );
  }
}
