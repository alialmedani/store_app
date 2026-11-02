import 'package:flutter/widgets.dart' as fw;
import 'package:store/core/ui/kit/app_kit.dart';
import '../../design_system/app_design_tokens.dart';

/// Consistent app header with back button, title, and optional actions
/// Used across all screens for unified navigation
class AppHeader extends fw.StatelessWidget {
  final String title;
  final fw.VoidCallback? onBack;
  final fw.Widget? action;
  final bool showBackButton;
  final bool withBorder;

  const AppHeader({
    super.key,
    required this.title,
    this.onBack,
    this.action,
    this.showBackButton = true,
    this.withBorder = true,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.sectionGap,
      ),
      child: fw.Row(
        children: [
          if (showBackButton) ...[
            IconButton(
              icon: const fw.Icon(Icons.arrow_back, size: 20),
              onPressed: onBack ?? () => fw.Navigator.pop(context),
              variance: ButtonVariance.ghost,
            ),
            const fw.SizedBox(width: AppDesignTokens.itemGap),
          ],
          fw.Expanded(
            child: Text(
              title,
              style: const fw.TextStyle(
                fontSize: AppDesignTokens.largeTitleFontSize,
                fontWeight: AppDesignTokens.bold,
                letterSpacing: AppDesignTokens.headingLetterSpacing,
              ),
            ),
          ),
          if (action != null) ...[
            const fw.SizedBox(width: AppDesignTokens.itemGap),
            action!,
          ],
        ],
      ),
    );
  }
}
