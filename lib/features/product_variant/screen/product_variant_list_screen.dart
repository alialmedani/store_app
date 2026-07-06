import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/model/product_variant_model.dart';
import 'variant_creation_options_screen.dart';
import 'product_variant_details_screen.dart';
import 'update_product_variant_screen.dart';

/// Product Variant List Screen - Shows all product variants with pagination
/// Uses PaginationList widget from boilerplate
class ProductVariantListScreen extends StatelessWidget {
  const ProductVariantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // App Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.background,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.border.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.muted.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, size: 20),
                          onPressed: () => fw.Navigator.of(context).pop(),
                          variance: ButtonVariance.ghost,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Product Variants',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
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
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final variant = list[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
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
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: PrimaryButton(
                  onPressed: () {
                    fw.Navigator.of(context).push(
                      fw.PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const VariantCreationOptionsScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  leading: const Icon(Icons.add, size: 20),
                  child: const Text(
                    'Add Variant',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
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

    return fw.GestureDetector(
      onTap: () {
        if (variant.id != null) {
          fw.Navigator.of(context).push(
            fw.PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ProductVariantDetailsScreen(productVariantId: variant.id!),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.border.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        variant.productName ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          if (variant.color != null &&
                              variant.color!.isNotEmpty)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.palette_outlined,
                                  size: 14,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  variant.color!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          if (variant.size != null && variant.size!.isNotEmpty)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.straighten,
                                  size: 14,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  variant.size!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),                // Edit Button
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () async {
                    await fw.Navigator.of(context).push(
                      fw.PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BlocProvider(
                          create: (ctx) => ProductVariantCubit(),
                          child: UpdateProductVariantScreen(
                            variant: variant,
                          ),
                        ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  variance: ButtonVariance.ghost,
                ),
                const SizedBox(width: 8),
                if (variant.isActive != null)
                  fw.Container(
                    padding: const fw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: fw.BoxDecoration(
                      color: variant.isActive!
                          ? const Color(0xFF10B981).withOpacity(0.12)
                          : const Color(0xFFEF4444).withOpacity(0.12),
                      borderRadius: fw.BorderRadius.circular(8),
                    ),
                    child: Text(
                      variant.isActive! ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: variant.isActive!
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 15,
                        color: theme.colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Stock: ${variant.stockQuantity ?? 0}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                if (variant.availabilityStatus != null)
                  fw.Container(
                    padding: const fw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: fw.BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.12),
                      borderRadius: fw.BorderRadius.circular(8),
                    ),
                    child: Text(
                      variant.availabilityStatus!.name ?? 'N/A',
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
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
