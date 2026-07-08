import 'package:flutter/widgets.dart' as fw;
import 'package:shimmer/shimmer.dart';
import '../../design_system/app_design_tokens.dart';

/// Skeleton loading components for consistent loading states
/// Uses shimmer effect to indicate loading progress
class AppSkeletonLoader {
  /// Creates a skeleton list suitable for bottom selectors
  /// Shows multiple skeleton rows that mimic the final list item structure
  static fw.Widget listItems({
    int itemCount = 6,
    bool withLeading = false,
    bool withSubtitle = false,
  }) {
    return fw.ListView.builder(
      padding: const fw.EdgeInsets.symmetric(
        vertical: AppDesignTokens.smallGap,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return _SkeletonListItem(
          withLeading: withLeading,
          withSubtitle: withSubtitle,
        );
      },
    );
  }

  /// Creates skeleton list for entity cards (like product list)
  /// Shows multiple skeleton cards that mimic EntityListCard structure
  static fw.Widget entityListItems({int itemCount = 5}) {
    return fw.ListView.builder(
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.screenPaddingHorizontal,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return fw.Padding(
          padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.cardGap),
          child: const _SkeletonEntityCard(),
        );
      },
    );
  }

  /// Creates a single skeleton box with shimmer effect
  static fw.Widget box({
    required double width,
    required double height,
    double? borderRadius,
  }) {
    return _ShimmerWrapper(
      child: fw.Container(
        width: width,
        height: height,
        decoration: fw.BoxDecoration(
          color: AppDesignTokens.mutedSurfaceColor,
          borderRadius: fw.BorderRadius.circular(
            borderRadius ?? AppDesignTokens.inputRadius,
          ),
        ),
      ),
    );
  }
}

/// Internal widget for a skeleton entity card (product/category cards)
class _SkeletonEntityCard extends fw.StatelessWidget {
  const _SkeletonEntityCard();

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
      decoration: fw.BoxDecoration(
        color: const fw.Color(0xFFFFFFFF),
        borderRadius: fw.BorderRadius.circular(AppDesignTokens.cardRadius),
        border: fw.Border.all(color: AppDesignTokens.borderColor, width: 1),
      ),
      child: fw.Row(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          // Image placeholder
          _ShimmerWrapper(
            child: fw.Container(
              width: 80,
              height: 80,
              decoration: fw.BoxDecoration(
                color: AppDesignTokens.mutedSurfaceColor,
                borderRadius: fw.BorderRadius.circular(
                  AppDesignTokens.inputRadius,
                ),
              ),
            ),
          ),
          const fw.SizedBox(width: AppDesignTokens.itemGap),
          // Content
          fw.Expanded(
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                // Title
                _ShimmerWrapper(
                  child: fw.Container(
                    width: double.infinity,
                    height: 18,
                    decoration: fw.BoxDecoration(
                      color: AppDesignTokens.mutedSurfaceColor,
                      borderRadius: fw.BorderRadius.circular(
                        AppDesignTokens.badgeRadius,
                      ),
                    ),
                  ),
                ),
                const fw.SizedBox(height: AppDesignTokens.smallGap),
                // Subtitle (price)
                _ShimmerWrapper(
                  child: fw.Container(
                    width: 80,
                    height: 16,
                    decoration: fw.BoxDecoration(
                      color: AppDesignTokens.mutedSurfaceColor,
                      borderRadius: fw.BorderRadius.circular(
                        AppDesignTokens.badgeRadius,
                      ),
                    ),
                  ),
                ),
                const fw.SizedBox(height: AppDesignTokens.smallGap),
                // Description line 1
                _ShimmerWrapper(
                  child: fw.Container(
                    width: double.infinity,
                    height: 12,
                    decoration: fw.BoxDecoration(
                      color: AppDesignTokens.mutedSurfaceColor,
                      borderRadius: fw.BorderRadius.circular(
                        AppDesignTokens.badgeRadius,
                      ),
                    ),
                  ),
                ),
                const fw.SizedBox(height: AppDesignTokens.tinyGap),
                // Description line 2
                _ShimmerWrapper(
                  child: fw.Container(
                    width: 120,
                    height: 12,
                    decoration: fw.BoxDecoration(
                      color: AppDesignTokens.mutedSurfaceColor,
                      borderRadius: fw.BorderRadius.circular(
                        AppDesignTokens.badgeRadius,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal widget for a single skeleton list item
class _SkeletonListItem extends fw.StatelessWidget {
  final bool withLeading;
  final bool withSubtitle;

  const _SkeletonListItem({
    this.withLeading = false,
    this.withSubtitle = false,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.symmetric(
        horizontal: AppDesignTokens.screenPaddingHorizontal,
        vertical: AppDesignTokens.itemGap,
      ),
      child: fw.Row(
        children: [
          if (withLeading) ...[
            _ShimmerWrapper(
              child: fw.Container(
                width: 40,
                height: 40,
                decoration: fw.BoxDecoration(
                  color: AppDesignTokens.mutedSurfaceColor,
                  borderRadius: fw.BorderRadius.circular(
                    AppDesignTokens.iconBoxRadius,
                  ),
                ),
              ),
            ),
            const fw.SizedBox(width: AppDesignTokens.itemGap),
          ],
          fw.Expanded(
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                _ShimmerWrapper(
                  child: fw.Container(
                    width: double.infinity,
                    height: 16,
                    decoration: fw.BoxDecoration(
                      color: AppDesignTokens.mutedSurfaceColor,
                      borderRadius: fw.BorderRadius.circular(
                        AppDesignTokens.badgeRadius,
                      ),
                    ),
                  ),
                ),
                if (withSubtitle) ...[
                  const fw.SizedBox(height: AppDesignTokens.smallGap),
                  _ShimmerWrapper(
                    child: fw.Container(
                      width: 150,
                      height: 12,
                      decoration: fw.BoxDecoration(
                        color: AppDesignTokens.mutedSurfaceColor,
                        borderRadius: fw.BorderRadius.circular(
                          AppDesignTokens.badgeRadius,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrapper widget that applies shimmer effect
class _ShimmerWrapper extends fw.StatelessWidget {
  final fw.Widget child;

  const _ShimmerWrapper({required this.child});

  @override
  fw.Widget build(fw.BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppDesignTokens.mutedSurfaceColor,
      highlightColor: const fw.Color(0xFFFFFFFF),
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}
