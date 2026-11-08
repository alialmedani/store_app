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
          child: AppTabHeader(
            title: 'cart'.tr(),
            subtitle: 'your_shopping_cart'.tr(),
            icon: Icons.shopping_cart_rounded,
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
                  const AppHeroIcon(Icons.shopping_cart_rounded),
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
