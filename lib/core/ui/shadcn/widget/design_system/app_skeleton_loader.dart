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
      highlightColor: AppDesignTokens.isDark
          ? const fw.Color(0x24FFFFFF)
          : const fw.Color(0xCCFFFFFF),
      period: const Duration(milliseconds: 1500),
      child: fw.Container(
        width: width,
        height: height,
        decoration: fw.BoxDecoration(
          color: const fw.Color(0xFFFFFFFF),
          borderRadius: fw.BorderRadius.circular(
            borderRadius ?? AppDesignTokens.badgeRadius,
          ),
        ),
      ),
    );
  }
}

/// Flat card decoration shared by skeletons that preview a non-elevated
/// surface (same as [AppDesignTokens.glassDecoration]).
fw.BoxDecoration _flatCardDecoration({double? radius}) =>
    AppDesignTokens.glassDecoration(radius: radius);

/// Elevated card decoration shared by skeletons that stand in for real
/// `AppCard(elevated: true)` surfaces (list rows via EntityListCard, dashboard
/// KPI/menu rows, detail cards). Mirrors [AppCard] with `elevated: true`:
/// flat paper/ink surface + Line hairline + the lifted [elevatedShadow].
fw.BoxDecoration _elevatedCardDecoration({double? radius}) => fw.BoxDecoration(
  color: AppDesignTokens.cardColor,
  borderRadius: fw.BorderRadius.circular(radius ?? AppDesignTokens.cardRadius),
  border: fw.Border.all(color: AppDesignTokens.glassBorder, width: 1),
  boxShadow: AppDesignTokens.elevatedShadow(),
);

/// A single left-aligned shimmer line sized as a fraction of the available
/// width. Used for the calm-silhouette "title"/"subtitle" lines so they never
/// look like a reconstructed field.
class _CalmLine extends fw.StatelessWidget {
  final double widthFactor;
  final double height;
  const _CalmLine({required this.widthFactor, this.height = 13});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.FractionallySizedBox(
      alignment: fw.AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      child: AppSkeletonBox(width: double.infinity, height: height),
    );
  }
}

/// Calm-silhouette card content (loading-state direction A):
/// a leading icon/image box + a wider "title" line and a shorter "subtitle"
/// line. NO faux chips, badges, metric tiles or nested boxes — the real card's
/// shell (shadow/radius/hairline) carries the structure; the inside stays calm.
/// Reused by every card/row skeleton so loading states read consistently.
class _CalmCardContent extends fw.StatelessWidget {
  final double leadingSize;
  final double leadingRadius;
  final double titleFactor;
  final double subtitleFactor;

  const _CalmCardContent({
    this.leadingSize = 48,
    this.leadingRadius = AppDesignTokens.iconBoxRadius,
    this.titleFactor = 0.66,
    this.subtitleFactor = 0.4,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        AppSkeletonBox(
          width: leadingSize,
          height: leadingSize,
          borderRadius: leadingRadius,
        ),
        const fw.SizedBox(width: AppDesignTokens.cardGap),
        fw.Expanded(
          child: fw.Padding(
            // Nudge the two lines down so they sit centered against the box.
            padding: const fw.EdgeInsets.only(top: 2),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                _CalmLine(widthFactor: titleFactor, height: 15),
                const fw.SizedBox(height: AppDesignTokens.smallGap + 2),
                _CalmLine(widthFactor: subtitleFactor, height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Skeleton for Product/Category list rows (elevated [EntityListCard] with an
/// 80x80 image). Calm silhouette: image box + title line + subtitle line.
class ProductCardSkeleton extends fw.StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
      decoration: _elevatedCardDecoration(),
      child: const _CalmCardContent(
        leadingSize: 80,
        leadingRadius: AppDesignTokens.inputRadius,
        titleFactor: 0.72,
        subtitleFactor: 0.45,
      ),
    );
  }
}

/// Skeleton for Category list rows (same shape as product rows).
class CategoryCardSkeleton extends fw.StatelessWidget {
  const CategoryCardSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return const ProductCardSkeleton();
  }
}

/// Skeleton for Product Variant list rows (elevated [EntityListCard]).
/// Calm silhouette: icon box + title line + subtitle line.
class ProductVariantCardSkeleton extends fw.StatelessWidget {
  const ProductVariantCardSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
      decoration: _elevatedCardDecoration(),
      child: const _CalmCardContent(),
    );
  }
}

/// Skeleton for Order list rows (elevated card). Calm silhouette.
class OrderCardSkeleton extends fw.StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
      decoration: _elevatedCardDecoration(),
      child: const _CalmCardContent(titleFactor: 0.5, subtitleFactor: 0.7),
    );
  }
}

/// Skeleton for Inventory Movement rows (elevated `AppCard(elevated: true)` with
/// `cardPaddingLarge`). Calm silhouette: icon box + title line + subtitle line.
class InventoryMovementCardSkeleton extends fw.StatelessWidget {
  const InventoryMovementCardSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(AppDesignTokens.cardPaddingLarge),
      decoration: _elevatedCardDecoration(),
      child: const _CalmCardContent(titleFactor: 0.6, subtitleFactor: 0.38),
    );
  }
}

/// Skeleton for selector list items. Already a calm icon(optional) + title line
/// (+ optional subtitle) shape, matching [SelectorTile].
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
                const _CalmLine(widthFactor: 0.7, height: 16),
                if (withSubtitle) ...[
                  const fw.SizedBox(height: AppDesignTokens.smallGap),
                  const _CalmLine(widthFactor: 0.45, height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Default skeleton for any list that is loading (elevated image rows).
class ListSkeleton extends fw.StatelessWidget {
  final int count;
  const ListSkeleton({super.key, this.count = 6});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.ListView.builder(
      physics: const fw.NeverScrollableScrollPhysics(),
      padding: const fw.EdgeInsets.all(AppDesignTokens.screenPaddingHorizontal),
      itemCount: count,
      itemBuilder: (context, index) => const fw.Padding(
        padding: fw.EdgeInsets.only(bottom: AppDesignTokens.cardGap),
        child: ProductCardSkeleton(),
      ),
    );
  }
}

/// Skeleton for report screens. Reports lead with a row of flat [StatCard]s then
/// flat [AppCard] sections, so this previews that shape with the calm-silhouette
/// language: KPI cards = icon box + two lines; sections = a block / plain lines.
class ReportSkeleton extends fw.StatelessWidget {
  const ReportSkeleton({super.key});

  // Flat KPI stat-card silhouette: icon box + a value line + a label line.
  fw.Widget _statCard() => fw.Container(
    padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
    decoration: _flatCardDecoration(),
    child: fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: const [
        AppSkeletonBox(
          width: 44,
          height: 44,
          borderRadius: AppDesignTokens.iconBoxRadius,
        ),
        fw.SizedBox(height: AppDesignTokens.itemGap),
        _CalmLine(widthFactor: 0.75, height: 22),
        fw.SizedBox(height: AppDesignTokens.smallGap),
        _CalmLine(widthFactor: 0.5, height: 12),
      ],
    ),
  );

  // Flat section card: either one big block (chart) or a few calm lines.
  fw.Widget _sectionCard({double chartHeight = 0, int lines = 0}) =>
      fw.Container(
        padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
        decoration: _flatCardDecoration(),
        child: fw.Column(
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            if (chartHeight > 0)
              AppSkeletonBox(width: double.infinity, height: chartHeight),
            for (var i = 0; i < lines; i++) ...[
              if (i > 0) const fw.SizedBox(height: AppDesignTokens.cardGap),
              _CalmLine(widthFactor: i.isEven ? 0.8 : 0.6, height: 13),
            ],
          ],
        ),
      );

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.ListView(
      physics: const fw.NeverScrollableScrollPhysics(),
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal,
        0,
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.sectionGap,
      ),
      children: [
        fw.Row(
          children: [
            fw.Expanded(child: _statCard()),
            const fw.SizedBox(width: AppDesignTokens.cardGap),
            fw.Expanded(child: _statCard()),
          ],
        ),
        const fw.SizedBox(height: AppDesignTokens.sectionGap),
        const _CalmLine(widthFactor: 0.45, height: 15),
        const fw.SizedBox(height: AppDesignTokens.itemGap),
        _sectionCard(chartHeight: 150),
        const fw.SizedBox(height: AppDesignTokens.sectionGap),
        const _CalmLine(widthFactor: 0.35, height: 15),
        const fw.SizedBox(height: AppDesignTokens.itemGap),
        _sectionCard(lines: 4),
      ],
    );
  }
}

/// Default skeleton for a details / edit page that is loading.
/// Calm silhouette: a hero row (avatar + title line) + elevated section cards,
/// each a short heading line + two body lines.
class DetailSkeleton extends fw.StatelessWidget {
  const DetailSkeleton({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    // Detail screens render elevated AppCard(elevated: true) sections.
    fw.Widget card() => fw.Container(
      padding: const fw.EdgeInsets.all(AppDesignTokens.cardPadding),
      decoration: _elevatedCardDecoration(),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: const [
          _CalmLine(widthFactor: 0.35, height: 14),
          fw.SizedBox(height: AppDesignTokens.itemGap),
          _CalmLine(widthFactor: 0.9, height: 12),
          fw.SizedBox(height: AppDesignTokens.smallGap),
          _CalmLine(widthFactor: 0.6, height: 12),
        ],
      ),
    );

    return fw.Padding(
      padding: const fw.EdgeInsets.all(AppDesignTokens.screenPaddingHorizontal),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          fw.Row(
            children: const [
              AppSkeletonBox(width: 46, height: 46, borderRadius: 99),
              fw.SizedBox(width: AppDesignTokens.itemGap),
              fw.Expanded(child: _CalmLine(widthFactor: 0.6, height: 22)),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.sectionGap),
          card(),
          const fw.SizedBox(height: AppDesignTokens.cardGap),
          card(),
          const fw.SizedBox(height: AppDesignTokens.cardGap),
          card(),
        ],
      ),
    );
  }
}

/// Skeleton for a horizontal strip of selectable chips/cards.
class ChipsRowSkeleton extends fw.StatelessWidget {
  final double width;
  final int count;
  const ChipsRowSkeleton({super.key, required this.width, this.count = 4});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.ListView.builder(
      scrollDirection: fw.Axis.horizontal,
      physics: const fw.NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, i) => fw.Padding(
        padding: const fw.EdgeInsetsDirectional.only(end: 8),
        child: AppSkeletonBox(
          width: width,
          height: double.infinity,
          borderRadius: AppDesignTokens.inputRadius,
        ),
      ),
    );
  }
}
