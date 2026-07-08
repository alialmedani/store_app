import 'package:flutter/widgets.dart' as fw;
import 'package:shimmer/shimmer.dart';
import '../../design_system/app_design_tokens.dart';

/// Reusable skeleton loading primitive
/// Use AppSkeletonBox to build custom skeleton layouts
class AppSkeletonBox extends fw.StatelessWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const AppSkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppDesignTokens.mutedSurfaceColor,
      highlightColor: const fw.Color(0xFFFFFFFF),
      period: const Duration(milliseconds: 1500),
      child: fw.Container(
        width: width,
        height: height,
        decoration: fw.BoxDecoration(
          color: AppDesignTokens.mutedSurfaceColor,
          borderRadius: fw.BorderRadius.circular(
            borderRadius ?? AppDesignTokens.badgeRadius,
          ),
        ),
      ),
    );
  }
}

/// Skeleton for Product/Category cards with images
class ProductCardSkeleton extends fw.StatelessWidget {
  const ProductCardSkeleton({super.key});

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
          const AppSkeletonBox(
            width: 80,
            height: 80,
            borderRadius: AppDesignTokens.inputRadius,
          ),
          const fw.SizedBox(width: AppDesignTokens.itemGap),
          fw.Expanded(
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                const AppSkeletonBox(width: double.infinity, height: 18),
                const fw.SizedBox(height: AppDesignTokens.smallGap),
                const AppSkeletonBox(width: 100, height: 14),
                const fw.SizedBox(height: AppDesignTokens.smallGap),
                const AppSkeletonBox(width: double.infinity, height: 12),
                const fw.SizedBox(height: AppDesignTokens.tinyGap),
                const AppSkeletonBox(width: 140, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for Category cards with images
class CategoryCardSkeleton extends fw.StatelessWidget {
  const CategoryCardSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return const ProductCardSkeleton(); // Same layout as product
  }
}

/// Skeleton for Product Variant cards without images
class ProductVariantCardSkeleton extends fw.StatelessWidget {
  const ProductVariantCardSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
      decoration: fw.BoxDecoration(
        color: const fw.Color(0xFFFFFFFF),
        borderRadius: fw.BorderRadius.circular(AppDesignTokens.cardRadius),
        border: fw.Border.all(color: AppDesignTokens.borderColor, width: 1),
      ),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          // Top row: Title + Status Badge + Edit Button
          fw.Row(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              // Title
              const fw.Expanded(
                child: AppSkeletonBox(
                  width: double.infinity,
                  height: 18,
                  borderRadius: 6,
                ),
              ),
              const fw.SizedBox(width: AppDesignTokens.smallGap),
              // Status badge
              const AppSkeletonBox(width: 60, height: 22, borderRadius: 8),
              const fw.SizedBox(width: AppDesignTokens.smallGap),
              // Edit button
              const AppSkeletonBox(width: 34, height: 34, borderRadius: 8),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),
          // Meta items row (color, size, stock)
          fw.Wrap(
            spacing: AppDesignTokens.cardGap,
            runSpacing: AppDesignTokens.smallGap,
            children: [
              // Meta item 1 (Color)
              fw.Row(
                mainAxisSize: fw.MainAxisSize.min,
                children: [
                  const AppSkeletonBox(width: 15, height: 15, borderRadius: 4),
                  const fw.SizedBox(width: 6),
                  const AppSkeletonBox(width: 50, height: 12, borderRadius: 4),
                ],
              ),
              // Meta item 2 (Size)
              fw.Row(
                mainAxisSize: fw.MainAxisSize.min,
                children: [
                  const AppSkeletonBox(width: 15, height: 15, borderRadius: 4),
                  const fw.SizedBox(width: 6),
                  const AppSkeletonBox(width: 35, height: 12, borderRadius: 4),
                ],
              ),
              // Meta item 3 (Stock)
              fw.Row(
                mainAxisSize: fw.MainAxisSize.min,
                children: [
                  const AppSkeletonBox(width: 15, height: 15, borderRadius: 4),
                  const fw.SizedBox(width: 6),
                  const AppSkeletonBox(width: 70, height: 12, borderRadius: 4),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton for Order cards
class OrderCardSkeleton extends fw.StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
      decoration: fw.BoxDecoration(
        color: const fw.Color(0xFFFFFFFF),
        borderRadius: fw.BorderRadius.circular(AppDesignTokens.cardRadius),
        border: fw.Border.all(color: AppDesignTokens.borderColor, width: 1),
      ),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          // Order Number, Date, and Edit Button
          fw.Row(
            mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
            children: [
              const fw.Expanded(child: AppSkeletonBox(width: 120, height: 18)),
              const AppSkeletonBox(width: 70, height: 12),
              const fw.SizedBox(width: 8),
              const AppSkeletonBox(width: 32, height: 32, borderRadius: 8),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),

          // Customer Name with icon
          fw.Row(
            children: [
              const AppSkeletonBox(width: 16, height: 16, borderRadius: 4),
              const fw.SizedBox(width: 8),
              const fw.Expanded(child: AppSkeletonBox(width: 150, height: 14)),
            ],
          ),
          const fw.SizedBox(height: 8),

          // Phone with icon
          fw.Row(
            children: [
              const AppSkeletonBox(width: 16, height: 16, borderRadius: 4),
              const fw.SizedBox(width: 8),
              const AppSkeletonBox(width: 120, height: 14),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),

          // Status badges
          fw.Row(
            children: [
              const AppSkeletonBox(
                width: 70,
                height: 22,
                borderRadius: AppDesignTokens.badgeRadius,
              ),
              const fw.SizedBox(width: 8),
              const AppSkeletonBox(
                width: 60,
                height: 22,
                borderRadius: AppDesignTokens.badgeRadius,
              ),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),

          // Total Amount container
          const AppSkeletonBox(width: 120, height: 32, borderRadius: 8),
        ],
      ),
    );
  }
}

/// Skeleton for Inventory Movement cards
/// Neutral gray placeholders only - no colors, no labels, no fake data
class InventoryMovementCardSkeleton extends fw.StatelessWidget {
  const InventoryMovementCardSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(20),
      decoration: fw.BoxDecoration(
        color: const fw.Color(0xFFFFFFFF),
        borderRadius: fw.BorderRadius.circular(12),
        border: fw.Border.all(color: AppDesignTokens.borderColor, width: 1),
      ),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          // Header: Icon and Product Info
          fw.Row(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              // Icon placeholder
              const AppSkeletonBox(width: 48, height: 48, borderRadius: 12),
              const fw.SizedBox(width: 14),
              // Product Details
              fw.Expanded(
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    const AppSkeletonBox(width: double.infinity, height: 18),
                    const fw.SizedBox(height: 8),
                    // Chips row
                    fw.Row(
                      children: [
                        const AppSkeletonBox(
                          width: 60,
                          height: 24,
                          borderRadius: 6,
                        ),
                        const fw.SizedBox(width: 8),
                        const AppSkeletonBox(
                          width: 50,
                          height: 24,
                          borderRadius: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const fw.SizedBox(height: 16),
          // Metrics row (stock and change boxes)
          fw.Row(
            children: [
              fw.Expanded(
                child: fw.Container(
                  padding: const fw.EdgeInsets.all(12),
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.mutedSurfaceColor.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: fw.BorderRadius.circular(10),
                    border: fw.Border.all(
                      color: AppDesignTokens.borderColor,
                      width: 1,
                    ),
                  ),
                  child: fw.Column(
                    crossAxisAlignment: fw.CrossAxisAlignment.start,
                    children: [
                      const AppSkeletonBox(width: 60, height: 12),
                      const fw.SizedBox(height: 6),
                      const AppSkeletonBox(width: 40, height: 20),
                    ],
                  ),
                ),
              ),
              const fw.SizedBox(width: 12),
              fw.Expanded(
                child: fw.Container(
                  padding: const fw.EdgeInsets.all(12),
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.mutedSurfaceColor.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: fw.BorderRadius.circular(10),
                    border: fw.Border.all(
                      color: AppDesignTokens.borderColor,
                      width: 1,
                    ),
                  ),
                  child: fw.Column(
                    crossAxisAlignment: fw.CrossAxisAlignment.start,
                    children: [
                      const AppSkeletonBox(width: 60, height: 12),
                      const fw.SizedBox(height: 6),
                      const AppSkeletonBox(width: 40, height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const fw.SizedBox(height: 16),
          // Metadata row
          fw.Row(
            children: [
              const AppSkeletonBox(width: 24, height: 14),
              const fw.SizedBox(width: 8),
              const AppSkeletonBox(width: 80, height: 14),
              const fw.SizedBox(width: 16),
              const AppSkeletonBox(width: 24, height: 14),
              const fw.SizedBox(width: 8),
              const AppSkeletonBox(width: 60, height: 14),
            ],
          ),
          const fw.SizedBox(height: 12),
          // Notes section placeholder
          fw.Container(
            padding: const fw.EdgeInsets.all(12),
            decoration: fw.BoxDecoration(
              color: AppDesignTokens.mutedSurfaceColor.withValues(alpha: 0.3),
              borderRadius: fw.BorderRadius.circular(8),
            ),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                const AppSkeletonBox(width: double.infinity, height: 12),
                const fw.SizedBox(height: 6),
                const AppSkeletonBox(width: 180, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for selector list items
class SelectorItemSkeleton extends fw.StatelessWidget {
  final bool withLeading;
  final bool withSubtitle;

  const SelectorItemSkeleton({
    super.key,
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
            const AppSkeletonBox(
              width: 40,
              height: 40,
              borderRadius: AppDesignTokens.iconBoxRadius,
            ),
            const fw.SizedBox(width: AppDesignTokens.itemGap),
          ],
          fw.Expanded(
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                const AppSkeletonBox(width: double.infinity, height: 16),
                if (withSubtitle) ...[
                  const fw.SizedBox(height: AppDesignTokens.smallGap),
                  const AppSkeletonBox(width: 150, height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
