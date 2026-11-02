import 'package:flutter/widgets.dart' as fw;
import 'package:store/core/ui/kit/app_kit.dart';
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
        gradient: fw.LinearGradient(
          begin: fw.Alignment.topCenter,
          end: fw.Alignment.bottomCenter,
          stops: const [0.0, 0.3],
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0),
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: fw.SafeArea(top: false, child: child),
    );
  }
}
