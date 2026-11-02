import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

/// Explore Screen - Placeholder for future features
class ExploreScreen extends fw.StatelessWidget {
  const ExploreScreen({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return AppSliverScreen(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: AppTabHeader(
            title: 'explore'.tr(),
            subtitle: 'discover_new_features'.tr(),
            icon: Icons.explore_rounded,
          ),
        ),

        // Content
        SliverFillRemaining(
          child: fw.Center(
            child: fw.Padding(
              padding: const fw.EdgeInsets.all(
                AppDesignTokens.screenPaddingHorizontal,
              ),
              child: fw.Column(
                mainAxisAlignment: fw.MainAxisAlignment.center,
                children: [
                  const AppHeroIcon(Icons.explore_rounded),
                  const fw.SizedBox(height: AppDesignTokens.sectionGap),
                  fw.Text(
                    'coming_soon'.tr(),
                    style: fw.TextStyle(
                      fontSize: 24,
                      fontWeight: AppDesignTokens.bold,
                    ),
                  ),
                  const fw.SizedBox(height: AppDesignTokens.itemGap),
                  fw.Text(
                    'explore_features_will_be_available_soo'.tr(),
                    textAlign: fw.TextAlign.center,
                    style: fw.TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.mutedForeground,
                      height: 1.5,
                    ),
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
