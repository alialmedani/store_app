import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../cubit/product_cubit.dart';
import '../data/model/product_model.dart';
import 'create_product_screen.dart';

/// Product List Screen - Shows all products with pagination
/// Uses PaginationList widget from boilerplate
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

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
                        onPressed: () => Navigator.pop(context),
                        variance: ButtonVariance.ghost,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Products',
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
                  child: PaginationList<ProductModel>(
                    withPagination: true,
                    withRefresh: true,
                    repositoryCallBack: (data) {
                      return context.read<ProductCubit>().fetchProductList(
                        data,
                      );
                    },
                    listBuilder: (list) {
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final product = list[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ProductCard(product: product),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateProductScreen(),
                    ),
                  );
                },
                leading: const Icon(Icons.add),
                child: const Text('Add Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product Card Widget
class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

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
                        product.name ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.description != null &&
                          product.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          product.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.mutedForeground,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (product.isActive ?? false)
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : const Color(0xFFEF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (product.isActive ?? false) ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: (product.isActive ?? false)
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  size: 16,
                  color: theme.colorScheme.mutedForeground,
                ),
                const SizedBox(width: 4),
                Text(
                  '${product.price?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Category and Target Audience
            Row(
              children: [
                // Category
                if (product.category?.name != null) ...[
                  Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: theme.colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.category!.name!,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],

                // Target Audience
                if (product.targetAudience?.name != null) ...[
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: theme.colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.targetAudience!.name!,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ],
            ),

            // Stock Quantity
            if (product.totalStockQuantity != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: theme.colorScheme.mutedForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Stock: ${product.totalStockQuantity}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
