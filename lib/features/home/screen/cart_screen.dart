import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

/// Cart Screen - Shopping Cart
class CartScreen extends fw.StatelessWidget {
  const CartScreen({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return AppSliverScreen(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: fw.Container(
            padding: const fw.EdgeInsets.fromLTRB(
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.screenPaddingHorizontal + 8,
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.sectionGap,
            ),
            decoration: fw.BoxDecoration(
              gradient: fw.LinearGradient(
                begin: fw.Alignment.topLeft,
                end: fw.Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.95),
                ],
              ),
              border: fw.Border(
                bottom: fw.BorderSide(
                  color: theme.colorScheme.border.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
            child: fw.Row(
              mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: fw.CrossAxisAlignment.center,
              children: [
                fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    fw.Text(
                      'cart'.tr(),
                      style: fw.TextStyle(
                        fontSize: 28,
                        fontWeight: AppDesignTokens.extraBold,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const fw.SizedBox(height: 4),
                    fw.Text(
                      'your_shopping_cart'.tr(),
                      style: fw.TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
                fw.Container(
                  padding: const fw.EdgeInsets.all(10),
                  decoration: fw.BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: fw.BorderRadius.circular(12),
                    border: fw.Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: fw.Icon(
                    Icons.shopping_cart_rounded,
                    size: 24,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Empty Cart State
        SliverFillRemaining(
          child: fw.Center(
            child: fw.Padding(
              padding: const fw.EdgeInsets.all(
                AppDesignTokens.screenPaddingHorizontal,
              ),
              child: fw.Column(
                mainAxisAlignment: fw.MainAxisAlignment.center,
                children: [
                  fw.Container(
                    padding: const fw.EdgeInsets.all(24),
                    decoration: fw.BoxDecoration(
                      color: theme.colorScheme.muted.withValues(alpha: 0.3),
                      borderRadius: fw.BorderRadius.circular(100),
                    ),
                    child: fw.Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                  const fw.SizedBox(height: AppDesignTokens.sectionGap),
                  fw.Text(
                    'your_cart_is_empty'.tr(),
                    style: fw.TextStyle(
                      fontSize: 24,
                      fontWeight: AppDesignTokens.bold,
                    ),
                  ),
                  const fw.SizedBox(height: AppDesignTokens.itemGap),
                  fw.Text(
                    'add_items_to_your_cart_to_see_them_her'.tr(),
                    textAlign: fw.TextAlign.center,
                    style: fw.TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.mutedForeground,
                      height: 1.5,
                    ),
                  ),
                  const fw.SizedBox(height: AppDesignTokens.sectionGap),
                  PrimaryButton(
                    onPressed: () {
                      // TODO: Navigate to products or show dialog
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('coming_soon'.tr()),
                          content: Text(
                            'shopping_cart_feature_will_be_availabl'.tr(),
                          ),
                          actions: [
                            PrimaryButton(
                              onPressed: () => fw.Navigator.pop(ctx),
                              child: Text('ok'.tr()),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('start_shopping'.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
