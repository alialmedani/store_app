import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/product_cubit.dart';
import '../data/model/product_model.dart';
import 'create_product_screen.dart';
import 'product_details_screen.dart';
import 'update_product_screen.dart';

/// Product List Screen - Shows all products with pagination
/// Uses PaginationList widget from boilerplate
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          children: [
            AppHeader(
              title: 'Products',
              onBack: () => fw.Navigator.pop(context),
            ),
            fw.Expanded(
              child: PaginationList<ProductModel>(
                withPagination: true,
                withRefresh: true,
                repositoryCallBack: (data) {
                  return context.read<ProductCubit>().fetchProductList(
                    data,
                  );
                },
                listBuilder: (list) {
                  return fw.ListView.builder(
                    padding: const fw.EdgeInsets.fromLTRB(
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.listBottomPadding,
                    ),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final product = list[index];
                          final imageUrl = ImageHelper.getProductImageUrl(
                            product.id ?? '',
                          );

                          final metaItems = <EntityMetaItem>[];
                          if (product.category?.name != null) {
                            metaItems.add(
                              EntityMetaItem(
                                icon: Icons.category_outlined,
                                text: product.category!.name!,
                              ),
                            );
                          }
                          if (product.targetAudience?.name != null) {
                            metaItems.add(
                              EntityMetaItem(
                                icon: Icons.people_outline,
                                text: product.targetAudience!.name!,
                              ),
                            );
                          }
                          if (product.totalStockQuantity != null) {
                            metaItems.add(
                              EntityMetaItem(
                                icon: Icons.inventory_2_outlined,
                                text: 'Stock: ${product.totalStockQuantity}',
                              ),
                            );
                          }

                          return fw.Padding(
                            padding: const fw.EdgeInsets.only(
                              bottom: AppDesignTokens.cardGap,
                            ),
                            child: EntityListCard(
                              title: product.name ?? 'N/A',
                              subtitle: product.price != null
                                  ? '\$${product.price!.toStringAsFixed(2)}'
                                  : null,
                              description: product.description,
                              image: AuthenticatedImage(
                                imageUrl: imageUrl,
                                width: 80,
                                height: 80,
                                fit: fw.BoxFit.cover,
                                errorWidget: fw.Center(
                                  child: fw.Icon(
                                    Icons.inventory_2_outlined,
                                    size: 32,
                                  ),
                                ),
                              ),
                              statusBadge: StatusBadge(
                                text: (product.isActive ?? false)
                                    ? 'Active'
                                    : 'Inactive',
                                type: (product.isActive ?? false)
                                    ? StatusBadgeType.active
                                    : StatusBadgeType.inactive,
                              ),
                              metaItems: metaItems.isNotEmpty
                                  ? metaItems
                                  : null,
                              onTap: () {
                                if (product.id != null) {
                                  fw.Navigator.push(
                                    context,
                                    fw.PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          ProductDetailsScreen(
                                            productId: product.id!,
                                          ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                }
                              },
                              onEdit: () {
                                fw.Navigator.push(
                                  context,
                                  fw.PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => BlocProvider(
                                      create: (_) => ProductCubit(),
                                      child: UpdateProductScreen(
                                        product: product,
                                      ),
                                    ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              StickyBottomAction(
                child: PrimaryButton(
                onPressed: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CreateProductScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                leading: const fw.Icon(Icons.add, size: 20),
                child: const Text(
                  'Add Product',
                  style: fw.TextStyle(
                    fontSize: 15,
                    fontWeight: AppDesignTokens.semiBold,
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

/// Product Card Widget
class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = ImageHelper.getProductImageUrl(product.id ?? '');

    return fw.GestureDetector(
      onTap: () {
        if (product.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsScreen(productId: product.id!),
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
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.muted.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.border.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AuthenticatedImage(
                      imageUrl: imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.muted.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: theme.colorScheme.mutedForeground,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
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
                                  product.name ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Price
                                Text(
                                  '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Edit Button
                          IconButton(
                            icon: const Icon(Icons.edit, size: 16),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => BlocProvider(
                                    create: (ctx) => ProductCubit(),
                                    child: UpdateProductScreen(
                                      product: product,
                                    ),
                                  ),
                                ),
                              );
                            },
                            variance: ButtonVariance.ghost,
                          ),
                          const SizedBox(width: 8),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: (product.isActive ?? false)
                                  ? const Color(0xFF10B981).withOpacity(0.12)
                                  : const Color(0xFFEF4444).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (product.isActive ?? false)
                                  ? 'Active'
                                  : 'Inactive',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: (product.isActive ?? false)
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (product.description != null &&
                product.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                product.description!,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.mutedForeground,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            // Metadata
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                // Category
                if (product.category?.name != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 15,
                        color: theme.colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.category!.name!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                // Target Audience
                if (product.targetAudience?.name != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 15,
                        color: theme.colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.targetAudience!.name!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                // Stock Quantity
                if (product.totalStockQuantity != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 15,
                        color: theme.colorScheme.mutedForeground,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Stock: ${product.totalStockQuantity}',
                        style: TextStyle(
                          fontSize: 12,
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
    );
  }
}
