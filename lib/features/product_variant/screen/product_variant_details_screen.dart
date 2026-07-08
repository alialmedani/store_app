import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/model/product_variant_model.dart';
import 'update_product_variant_screen.dart';

/// Product Variant Details Screen - Shows complete product variant information
class ProductVariantDetailsScreen extends fw.StatelessWidget {
  final String productVariantId;

  const ProductVariantDetailsScreen({
    super.key,
    required this.productVariantId,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => ProductVariantCubit(),
      child: Scaffold(
        child: SafeArea(
          child: GetModel<ProductVariantModel>(
            useCaseCallBack: () => context
                .read<ProductVariantCubit>()
                .getProductVariantDetails(productVariantId),
            modelBuilder: (variant) {
              return fw.Column(
                children: [
                  // App Bar
                  Container(
                    padding: const fw.EdgeInsets.fromLTRB(16, 16, 20, 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.border.withValues(
                            alpha: 0.1,
                          ),
                          width: 1,
                        ),
                      ),
                    ),
                    child: fw.Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.muted.withValues(
                              alpha: 0.3,
                            ),
                            borderRadius: fw.BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, size: 20),
                            onPressed: () => fw.Navigator.of(context).pop(),
                            variance: ButtonVariance.ghost,
                          ),
                        ),
                        const fw.SizedBox(width: 12),
                        const fw.Expanded(
                          child: Text(
                            'Variant Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () async {
                            final result = await fw.Navigator.of(context).push(
                              fw.PageRouteBuilder(
                                pageBuilder: (_, __, ___) => BlocProvider.value(
                                  value: context.read<ProductVariantCubit>(),
                                  child: UpdateProductVariantScreen(
                                    variant: variant,
                                  ),
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );

                            // Refresh details if variant was updated
                            if (result != null) {
                              // Trigger a rebuild by calling the details API again
                              context
                                  .read<ProductVariantCubit>()
                                  .getProductVariantDetails(productVariantId);
                            }
                          },
                          variance: ButtonVariance.ghost,
                        ),
                      ],
                    ),
                  ),

                  // Content
                  fw.Expanded(
                    child: fw.SingleChildScrollView(
                      padding: const fw.EdgeInsets.all(20),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          // Product Name Header
                          Container(
                            width: double.infinity,
                            padding: const fw.EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  theme.colorScheme.secondary.withValues(
                                    alpha: 0.15,
                                  ),
                                ],
                                begin: fw.Alignment.topLeft,
                                end: fw.Alignment.bottomRight,
                              ),
                              borderRadius: fw.BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.colorScheme.border.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.mutedForeground,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const fw.SizedBox(height: 8),
                                Text(
                                  variant.productName ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const fw.SizedBox(height: 24),

                          // Variant Info Cards
                          fw.Row(
                            children: [
                              if (variant.color != null &&
                                  variant.color!.isNotEmpty)
                                fw.Expanded(
                                  child: Container(
                                    padding: const fw.EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.card,
                                      borderRadius: fw.BorderRadius.circular(
                                        16,
                                      ),
                                      border: Border.all(
                                        color: theme.colorScheme.border
                                            .withValues(alpha: 0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: fw.Column(
                                      crossAxisAlignment:
                                          fw.CrossAxisAlignment.start,
                                      children: [
                                        fw.Row(
                                          children: [
                                            Icon(
                                              Icons.palette_outlined,
                                              size: 18,
                                              color: theme.colorScheme.primary,
                                            ),
                                            const fw.SizedBox(width: 6),
                                            Text(
                                              'Color',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: theme
                                                    .colorScheme
                                                    .mutedForeground,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const fw.SizedBox(height: 8),
                                        Text(
                                          variant.color!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (variant.color != null &&
                                  variant.color!.isNotEmpty &&
                                  variant.size != null &&
                                  variant.size!.isNotEmpty)
                                const fw.SizedBox(width: 12),
                              if (variant.size != null &&
                                  variant.size!.isNotEmpty)
                                fw.Expanded(
                                  child: Container(
                                    padding: const fw.EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.card,
                                      borderRadius: fw.BorderRadius.circular(
                                        16,
                                      ),
                                      border: Border.all(
                                        color: theme.colorScheme.border
                                            .withValues(alpha: 0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: fw.Column(
                                      crossAxisAlignment:
                                          fw.CrossAxisAlignment.start,
                                      children: [
                                        fw.Row(
                                          children: [
                                            Icon(
                                              Icons.straighten_outlined,
                                              size: 18,
                                              color: theme.colorScheme.primary,
                                            ),
                                            const fw.SizedBox(width: 6),
                                            Text(
                                              'Size',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: theme
                                                    .colorScheme
                                                    .mutedForeground,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const fw.SizedBox(height: 8),
                                        Text(
                                          variant.size!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const fw.SizedBox(height: 12),

                          // Stock & Status Row
                          fw.Row(
                            children: [
                              fw.Expanded(
                                child: Container(
                                  padding: const fw.EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.card,
                                    borderRadius: fw.BorderRadius.circular(16),
                                    border: Border.all(
                                      color: theme.colorScheme.border
                                          .withValues(alpha: 0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: fw.Column(
                                    crossAxisAlignment:
                                        fw.CrossAxisAlignment.start,
                                    children: [
                                      fw.Row(
                                        children: [
                                          Icon(
                                            Icons.inventory_2_outlined,
                                            size: 18,
                                            color: theme.colorScheme.primary,
                                          ),
                                          const fw.SizedBox(width: 6),
                                          Text(
                                            'Stock',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: theme
                                                  .colorScheme
                                                  .mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const fw.SizedBox(height: 8),
                                      Text(
                                        variant.stockQuantity?.toString() ??
                                            '0',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const fw.SizedBox(width: 12),
                              Container(
                                padding: const fw.EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: variant.isActive == true
                                      ? theme.colorScheme.primary.withValues(
                                          alpha: 0.1,
                                        )
                                      : theme.colorScheme.muted.withValues(
                                          alpha: 0.3,
                                        ),
                                  borderRadius: fw.BorderRadius.circular(16),
                                  border: Border.all(
                                    color: variant.isActive == true
                                        ? theme.colorScheme.primary.withValues(
                                            alpha: 0.3,
                                          )
                                        : theme.colorScheme.border.withValues(
                                            alpha: 0.3,
                                          ),
                                    width: 1,
                                  ),
                                ),
                                child: fw.Column(
                                  children: [
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 8),
                                    Text(
                                      variant.isActive == true
                                          ? 'Active'
                                          : 'Inactive',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: variant.isActive == true
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const fw.SizedBox(height: 24),

                          // Details Section
                          Text(
                            'Details',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const fw.SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const fw.EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.card,
                              borderRadius: fw.BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.border.withValues(
                                  alpha: 0.5,
                                ),
                                width: 1,
                              ),
                            ),
                            child: fw.Column(
                              children: [
                                _DetailRow(
                                  label: 'Product ID',
                                  value: variant.productId ?? 'N/A',
                                  theme: theme,
                                ),
                                const fw.SizedBox(height: 16),
                                _DetailRow(
                                  label: 'Availability',
                                  value:
                                      variant.availabilityStatus?.name ?? 'N/A',
                                  theme: theme,
                                ),
                                if (variant.creationTime != null) ...[
                                  const fw.SizedBox(height: 16),
                                  _DetailRow(
                                    label: 'Created',
                                    value: _formatDate(variant.creationTime!),
                                    theme: theme,
                                  ),
                                ],
                                if (variant.lastModificationTime != null) ...[
                                  const fw.SizedBox(height: 16),
                                  _DetailRow(
                                    label: 'Last Modified',
                                    value: _formatDate(
                                      variant.lastModificationTime!,
                                    ),
                                    theme: theme,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends fw.StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        fw.Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ),
        fw.Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.foreground,
            ),
          ),
        ),
      ],
    );
  }
}
