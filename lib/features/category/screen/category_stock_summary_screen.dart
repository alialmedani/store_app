import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_stock_summary_model.dart';

/// Category Stock Summary Screen - Shows category stock overview with pagination
/// Displays product/variant counts and stock status per category
class CategoryStockSummaryScreen extends fw.StatelessWidget {
  const CategoryStockSummaryScreen({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          children: [
            AppHeader(
              title: 'Category Stock Summary',
              onBack: () => fw.Navigator.pop(context),
            ),
            fw.Expanded(
              child: PaginationList<CategoryStockSummaryModel>(
                withPagination: true,
                withRefresh: true,
                repositoryCallBack: (data) {
                  return context
                      .read<CategoryCubit>()
                      .fetchCategoryStockSummary(data);
                },
                listBuilder: (list) {
                  return fw.ListView.builder(
                    padding: const fw.EdgeInsets.fromLTRB(
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final summary = list[index];
                      return fw.Padding(
                        padding: const fw.EdgeInsets.only(bottom: 16),
                        child: _StockSummaryCard(summary: summary),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stock Summary Card Widget - Premium design
class _StockSummaryCard extends fw.StatelessWidget {
  final CategoryStockSummaryModel summary;

  const _StockSummaryCard({required this.summary});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          // Header: Category Name + Status Badges
          fw.Row(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              fw.Expanded(
                child: Text(
                  summary.categoryName ?? 'N/A',
                  style: const fw.TextStyle(
                    fontSize: 18,
                    fontWeight: fw.FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const fw.SizedBox(width: 12),
              // Active Status Badge
              fw.Container(
                padding: const fw.EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: fw.BoxDecoration(
                  color: (summary.isActive ?? false)
                      ? const fw.Color(0xFF10B981).withValues(alpha: 0.12)
                      : const fw.Color(0xFFEF4444).withValues(alpha: 0.12),
                  borderRadius: fw.BorderRadius.circular(8),
                ),
                child: Text(
                  (summary.isActive ?? false) ? 'Active' : 'Inactive',
                  style: fw.TextStyle(
                    fontSize: 12,
                    fontWeight: fw.FontWeight.w600,
                    color: (summary.isActive ?? false)
                        ? const fw.Color(0xFF10B981)
                        : const fw.Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),

          const fw.SizedBox(height: 16),

          // Availability Status Badge (if available)
          if (summary.availabilityStatus?.name != null) ...[
            fw.Container(
              padding: const fw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: fw.BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: fw.BorderRadius.circular(10),
                border: fw.Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: fw.Row(
                mainAxisSize: fw.MainAxisSize.min,
                children: [
                  fw.Icon(
                    Icons.inventory_2_outlined,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const fw.SizedBox(width: 6),
                  Text(
                    summary.availabilityStatus!.name!,
                    style: fw.TextStyle(
                      fontSize: 12,
                      fontWeight: fw.FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const fw.SizedBox(height: 16),
          ],

          // Product & Variant Counts Section
          fw.Container(
            padding: const fw.EdgeInsets.all(16),
            decoration: fw.BoxDecoration(
              color: theme.colorScheme.muted.withValues(alpha: 0.2),
              borderRadius: fw.BorderRadius.circular(12),
              border: fw.Border.all(
                color: theme.colorScheme.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: fw.Column(
              children: [
                // Products Row
                fw.Row(
                  children: [
                    fw.Expanded(
                      child: _StatItem(
                        icon: Icons.inventory_2_rounded,
                        label: 'Products',
                        value: '${summary.productCount ?? 0}',
                        color: const fw.Color(0xFF10B981),
                      ),
                    ),
                    const fw.SizedBox(width: 12),
                    fw.Expanded(
                      child: _StatItem(
                        icon: Icons.check_circle_rounded,
                        label: 'Active',
                        value: '${summary.activeProducts ?? 0}',
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const fw.SizedBox(width: 12),
                    fw.Expanded(
                      child: _StatItem(
                        icon: Icons.cancel_rounded,
                        label: 'Inactive',
                        value: '${summary.inactiveProducts ?? 0}',
                        color: const fw.Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const fw.SizedBox(height: 12),
                // Variants Row
                fw.Row(
                  children: [
                    fw.Expanded(
                      child: _StatItem(
                        icon: Icons.style_rounded,
                        label: 'Variants',
                        value: '${summary.variantCount ?? 0}',
                        color: const fw.Color(0xFF06B6D4),
                      ),
                    ),
                    const fw.SizedBox(width: 12),
                    fw.Expanded(
                      child: _StatItem(
                        icon: Icons.check_circle_rounded,
                        label: 'Active',
                        value: '${summary.activeVariants ?? 0}',
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const fw.SizedBox(width: 12),
                    fw.Expanded(
                      child: _StatItem(
                        icon: Icons.cancel_rounded,
                        label: 'Inactive',
                        value: '${summary.inactiveVariants ?? 0}',
                        color: const fw.Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const fw.SizedBox(height: 16),

          // Stock Status Section
          fw.Container(
            padding: const fw.EdgeInsets.all(16),
            decoration: fw.BoxDecoration(
              gradient: fw.LinearGradient(
                begin: fw.Alignment.topLeft,
                end: fw.Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                  theme.colorScheme.primary.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: fw.BorderRadius.circular(12),
              border: fw.Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                fw.Row(
                  children: [
                    fw.Icon(
                      Icons.warehouse_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const fw.SizedBox(width: 6),
                    Text(
                      'Stock Overview',
                      style: fw.TextStyle(
                        fontSize: 13,
                        fontWeight: fw.FontWeight.w700,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                const fw.SizedBox(height: 12),
                // Product Stock Status
                fw.Row(
                  children: [
                    fw.Expanded(
                      child: _StockStatusItem(
                        label: 'In Stock',
                        products: summary.inStockProducts ?? 0,
                        variants: summary.inStockVariants ?? 0,
                        color: const fw.Color(0xFF10B981),
                        icon: Icons.check_circle,
                      ),
                    ),
                    const fw.SizedBox(width: 12),
                    fw.Expanded(
                      child: _StockStatusItem(
                        label: 'Low Stock',
                        products: summary.lowStockProducts ?? 0,
                        variants: summary.lowStockVariants ?? 0,
                        color: const fw.Color(0xFFF59E0B),
                        icon: Icons.warning,
                      ),
                    ),
                    const fw.SizedBox(width: 12),
                    fw.Expanded(
                      child: _StockStatusItem(
                        label: 'Out of Stock',
                        products: summary.outOfStockProducts ?? 0,
                        variants: summary.outOfStockVariants ?? 0,
                        color: const fw.Color(0xFFEF4444),
                        icon: Icons.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Total Stock Quantity & Threshold
          if (summary.totalStockQuantity != null ||
              summary.lowStockThreshold != null) ...[
            const fw.SizedBox(height: 16),
            fw.Row(
              children: [
                if (summary.totalStockQuantity != null)
                  fw.Expanded(
                    child: fw.Container(
                      padding: const fw.EdgeInsets.all(12),
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.muted.withValues(alpha: 0.2),
                        borderRadius: fw.BorderRadius.circular(10),
                      ),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Stock',
                            style: fw.TextStyle(
                              fontSize: 11,
                              fontWeight: fw.FontWeight.w600,
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                          const fw.SizedBox(height: 4),
                          Text(
                            '${summary.totalStockQuantity}',
                            style: const fw.TextStyle(
                              fontSize: 18,
                              fontWeight: fw.FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (summary.totalStockQuantity != null &&
                    summary.lowStockThreshold != null)
                  const fw.SizedBox(width: 12),
                if (summary.lowStockThreshold != null)
                  fw.Expanded(
                    child: fw.Container(
                      padding: const fw.EdgeInsets.all(12),
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.muted.withValues(alpha: 0.2),
                        borderRadius: fw.BorderRadius.circular(10),
                      ),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Low Threshold',
                            style: fw.TextStyle(
                              fontSize: 11,
                              fontWeight: fw.FontWeight.w600,
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                          const fw.SizedBox(height: 4),
                          Text(
                            '${summary.lowStockThreshold}',
                            style: const fw.TextStyle(
                              fontSize: 18,
                              fontWeight: fw.FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Stat Item Widget - Small stat display
class _StatItem extends fw.StatelessWidget {
  final fw.IconData icon;
  final String label;
  final String value;
  final fw.Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Column(
      children: [
        fw.Icon(icon, size: 18, color: color),
        const fw.SizedBox(height: 6),
        Text(
          value,
          style: const fw.TextStyle(
            fontSize: 16,
            fontWeight: fw.FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const fw.SizedBox(height: 2),
        Text(
          label,
          style: fw.TextStyle(
            fontSize: 10,
            fontWeight: fw.FontWeight.w600,
            color: theme.colorScheme.mutedForeground,
          ),
          textAlign: fw.TextAlign.center,
        ),
      ],
    );
  }
}

/// Stock Status Item Widget - Stock status display
class _StockStatusItem extends fw.StatelessWidget {
  final String label;
  final int products;
  final int variants;
  final fw.Color color;
  final fw.IconData icon;

  const _StockStatusItem({
    required this.label,
    required this.products,
    required this.variants,
    required this.color,
    required this.icon,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Container(
      padding: const fw.EdgeInsets.all(10),
      decoration: fw.BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: fw.BorderRadius.circular(10),
        border: fw.Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: fw.Column(
        children: [
          fw.Icon(icon, size: 16, color: color),
          const fw.SizedBox(height: 6),
          Text(
            label,
            style: fw.TextStyle(
              fontSize: 10,
              fontWeight: fw.FontWeight.w600,
              color: theme.colorScheme.mutedForeground,
            ),
            textAlign: fw.TextAlign.center,
          ),
          const fw.SizedBox(height: 4),
          Text(
            'P: $products',
            style: fw.TextStyle(
              fontSize: 11,
              fontWeight: fw.FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            'V: $variants',
            style: fw.TextStyle(
              fontSize: 11,
              fontWeight: fw.FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
