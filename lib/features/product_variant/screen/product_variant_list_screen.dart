import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/model/product_variant_model.dart';
import 'create_product_variant_screen.dart';

/// Product Variant List Screen - Shows all product variants with pagination
/// Uses PaginationList widget from boilerplate
class ProductVariantListScreen extends StatelessWidget {
  const ProductVariantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => fw.Navigator.of(context).pop(),
                        variance: ButtonVariance.ghost,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Product Variants',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: PaginationList<ProductVariantModel>(
                    withPagination: true,
                    withRefresh: true,
                    repositoryCallBack: (data) {
                      return context
                          .read<ProductVariantCubit>()
                          .fetchProductVariantList(data);
                    },
                    listBuilder: (list) {
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final variant = list[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ProductVariantCard(variant: variant),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            // Floating Action Button
            Positioned(
              right: 16,
              bottom: 16,
              child: PrimaryButton(
                onPressed: () {
                  fw.Navigator.of(context).push(
                    fw.PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const CreateProductVariantScreen(),
                    ),
                  );
                },
                leading: const Icon(Icons.add),
                child: const Text('Add Variant'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product Variant Card Widget
class _ProductVariantCard extends StatelessWidget {
  final ProductVariantModel variant;

  const _ProductVariantCard({required this.variant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        variant.productName ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (variant.color != null &&
                              variant.color!.isNotEmpty) ...[
                            Text(
                              'Color: ${variant.color}',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (variant.size != null &&
                              variant.size!.isNotEmpty) ...[
                            Text(
                              'Size: ${variant.size}',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (variant.isActive != null)
                  fw.Container(
                    padding: const fw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: fw.BoxDecoration(
                      color: variant.isActive!
                          ? theme.colorScheme.primary
                          : theme.colorScheme.muted,
                      borderRadius: fw.BorderRadius.circular(4),
                    ),
                    child: Text(
                      variant.isActive! ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: variant.isActive!
                            ? theme.colorScheme.primaryForeground
                            : theme.colorScheme.mutedForeground,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 16,
                        color: theme.colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Stock: ${variant.stockQuantity ?? 0}',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                if (variant.availabilityStatus != null)
                  fw.Container(
                    padding: const fw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: fw.BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: fw.BorderRadius.circular(4),
                    ),
                    child: Text(
                      variant.availabilityStatus!.name ?? 'N/A',
                      style: TextStyle(
                        color: theme.colorScheme.secondaryForeground,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
