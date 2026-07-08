import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/ui/shadcn/widget/design_system/design_system.dart';

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
                  theme.colorScheme.background,
                  theme.colorScheme.background.withValues(alpha: 0.95),
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
                    const fw.Text(
                      'Explore',
                      style: fw.TextStyle(
                        fontSize: 28,
                        fontWeight: AppDesignTokens.extraBold,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const fw.SizedBox(height: 4),
                    fw.Text(
                      'Discover new features',
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
                    Icons.explore_rounded,
                    size: 24,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
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
                  fw.Container(
                    padding: const fw.EdgeInsets.all(24),
                    decoration: fw.BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: fw.BorderRadius.circular(100),
                    ),
                    child: fw.Icon(
                      Icons.explore_outlined,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const fw.SizedBox(height: AppDesignTokens.sectionGap),
                  const fw.Text(
                    'Coming Soon',
                    style: fw.TextStyle(
                      fontSize: 24,
                      fontWeight: AppDesignTokens.bold,
                    ),
                  ),
                  const fw.SizedBox(height: AppDesignTokens.itemGap),
                  fw.Text(
                    'Explore features will be available soon.\nStay tuned for updates!',
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
