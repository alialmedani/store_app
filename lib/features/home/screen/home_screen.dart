import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../../core/ui/widgets/authenticated_image.dart';
import '../../../core/utils/image_helper.dart';
import '../../category/cubit/category_cubit.dart';
import '../../category/data/model/category_model.dart';
import '../../category/screen/category_details_screen.dart';
import '../../product/cubit/product_cubit.dart';
import '../../product/data/model/product_model.dart';
import '../../product/screen/product_details_screen.dart';
import '../../product/screen/product_list_screen.dart';

/// Home Screen - Products and Categories
class HomeScreen extends fw.StatelessWidget {
  const HomeScreen({super.key});

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
                      'Discover',
                      style: fw.TextStyle(
                        fontSize: 28,
                        fontWeight: AppDesignTokens.extraBold,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const fw.SizedBox(height: 4),
                    fw.Text(
                      'Browse products & categories',
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
                    Icons.shopping_bag_rounded,
                    size: 24,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Categories Section Header
        SliverToBoxAdapter(
          child: fw.Padding(
            padding: const fw.EdgeInsets.fromLTRB(
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.sectionGap,
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.cardGap,
            ),
            child: fw.Row(
              mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
              children: [
                fw.Row(
                  children: [
                    fw.Container(
                      width: 3,
                      height: 20,
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: fw.BorderRadius.circular(1.5),
                      ),
                    ),
                    const fw.SizedBox(width: AppDesignTokens.itemGap),
                    const fw.Text(
                      'Categories',
                      style: fw.TextStyle(
                        fontSize: 20,
                        fontWeight: AppDesignTokens.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Categories Horizontal List
        SliverToBoxAdapter(
          child: fw.SizedBox(
            height: 120,
            child: PaginationList<CategoryModel>(
              scrollDirection: fw.Axis.horizontal,
              withPagination: false,
              withRefresh: false,
              physics: const fw.BouncingScrollPhysics(),
              loadingWidget: fw.ListView.builder(
                scrollDirection: fw.Axis.horizontal,
                padding: const fw.EdgeInsets.symmetric(
                  horizontal: AppDesignTokens.screenPaddingHorizontal,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return fw.Padding(
                    padding: fw.EdgeInsets.only(
                      right: index < 4 ? AppDesignTokens.cardGap : 0,
                    ),
                    child: fw.Container(
                      width: 110,
                      decoration: fw.BoxDecoration(
                        color: AppDesignTokens.mutedSurfaceColor,
                        borderRadius: fw.BorderRadius.circular(16),
                        border: fw.Border.all(
                          color: AppDesignTokens.borderColor.withValues(
                            alpha: 0.2,
                          ),
                          width: 1,
                        ),
                      ),
                      padding: const fw.EdgeInsets.all(12),
                      child: fw.Column(
                        mainAxisAlignment: fw.MainAxisAlignment.center,
                        children: [
                          const AppSkeletonBox(
                            width: 48,
                            height: 48,
                            borderRadius: 12,
                          ),
                          const fw.SizedBox(height: 8),
                          const AppSkeletonBox(
                            width: 70,
                            height: 13,
                            borderRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              repositoryCallBack: (data) {
                return context.read<CategoryCubit>().fetchCategoryList(data);
              },
              listBuilder: (categories) {
                return fw.ListView.builder(
                  scrollDirection: fw.Axis.horizontal,
                  padding: const fw.EdgeInsets.symmetric(
                    horizontal: AppDesignTokens.screenPaddingHorizontal,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return fw.Padding(
                      padding: fw.EdgeInsets.only(
                        right: index < categories.length - 1
                            ? AppDesignTokens.cardGap
                            : 0,
                      ),
                      child: _CategoryCard(category: category),
                    );
                  },
                );
              },
            ),
          ),
        ),

        // Products Section Header
        SliverToBoxAdapter(
          child: fw.Padding(
            padding: const fw.EdgeInsets.fromLTRB(
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.sectionGap,
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.cardGap,
            ),
            child: fw.Row(
              mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
              children: [
                fw.Row(
                  children: [
                    fw.Container(
                      width: 3,
                      height: 20,
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: fw.BorderRadius.circular(1.5),
                      ),
                    ),
                    const fw.SizedBox(width: AppDesignTokens.itemGap),
                    const fw.Text(
                      'Products',
                      style: fw.TextStyle(
                        fontSize: 20,
                        fontWeight: AppDesignTokens.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                fw.GestureDetector(
                  onTap: () {
                    fw.Navigator.push(
                      context,
                      fw.PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ProductListScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: fw.Text(
                    'See All',
                    style: fw.TextStyle(
                      fontSize: 14,
                      fontWeight: fw.FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Products Grid
        SliverToBoxAdapter(
          child: fw.SizedBox(
            height: 550,
            child: PaginationList<ProductModel>(
              loadingWidget: fw.GridView.builder(
                padding: const fw.EdgeInsets.fromLTRB(
                  AppDesignTokens.screenPaddingHorizontal,
                  0,
                  AppDesignTokens.screenPaddingHorizontal,
                  AppDesignTokens.sectionGap + 60,
                ),
                physics: const fw.NeverScrollableScrollPhysics(),
                gridDelegate:
                    const fw.SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 260,
                    ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _ProductCardSkeleton();
                },
              ),
              repositoryCallBack: (data) {
                return context.read<ProductCubit>().fetchProductList(data);
              },
              listBuilder: (products) {
                final displayProducts = products.take(6).toList();
                return fw.GridView.builder(
                  padding: const fw.EdgeInsets.fromLTRB(
                    AppDesignTokens.screenPaddingHorizontal,
                    0,
                    AppDesignTokens.screenPaddingHorizontal,
                    AppDesignTokens.sectionGap + 60,
                  ),
                  physics: const fw.NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const fw.SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 260,
                      ),
                  itemCount: displayProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayProducts[index];
                    return _ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Category Card Widget
class _CategoryCard extends fw.StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({required this.category});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = ImageHelper.getCategoryImageUrl(category.id ?? '');

    return fw.GestureDetector(
      onTap: () {
        fw.Navigator.push(
          context,
          fw.PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                CategoryDetailsScreen(categoryId: category.id ?? ''),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: fw.Container(
        width: 110,
        decoration: fw.BoxDecoration(
          color: theme.colorScheme.card,
          borderRadius: fw.BorderRadius.circular(16),
          border: fw.Border.all(
            color: theme.colorScheme.border.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        padding: const fw.EdgeInsets.all(12),
        child: fw.Column(
          mainAxisAlignment: fw.MainAxisAlignment.center,
          children: [
            fw.ClipRRect(
              borderRadius: fw.BorderRadius.circular(12),
              child: AuthenticatedImage(
                imageUrl: imageUrl,
                width: 48,
                height: 48,
                fit: fw.BoxFit.cover,
                errorWidget: fw.Container(
                  width: 48,
                  height: 48,
                  decoration: fw.BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: fw.BorderRadius.circular(12),
                  ),
                  child: fw.Center(
                    child: fw.Icon(
                      Icons.category_rounded,
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const fw.SizedBox(height: 8),
            fw.Text(
              category.name ?? 'Unknown',
              maxLines: 2,
              textAlign: fw.TextAlign.center,
              overflow: fw.TextOverflow.ellipsis,
              style: const fw.TextStyle(
                fontSize: 13,
                fontWeight: fw.FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product Card Widget
class _ProductCard extends fw.StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = ImageHelper.getProductImageUrl(product.id ?? '');

    return fw.GestureDetector(
      onTap: () {
        fw.Navigator.push(
          context,
          fw.PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ProductDetailsScreen(productId: product.id ?? ''),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Card(
        child: fw.Column(
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            // Product Image
            fw.ClipRRect(
              borderRadius: const fw.BorderRadius.vertical(
                top: fw.Radius.circular(12),
              ),
              child: AuthenticatedImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 140,
                fit: fw.BoxFit.cover,
                errorWidget: fw.Container(
                  height: 140,
                  decoration: fw.BoxDecoration(
                    color: theme.colorScheme.muted.withValues(alpha: 0.3),
                    borderRadius: const fw.BorderRadius.vertical(
                      top: fw.Radius.circular(12),
                    ),
                  ),
                  child: fw.Center(
                    child: fw.Icon(
                      Icons.inventory_2_rounded,
                      size: 48,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ),
              ),
            ),
            // Product Info
            fw.Padding(
              padding: const fw.EdgeInsets.all(8),
              child: fw.Column(
                crossAxisAlignment: fw.CrossAxisAlignment.start,
                children: [
                  fw.Text(
                    product.name ?? 'Unknown',
                    maxLines: 1,
                    overflow: fw.TextOverflow.ellipsis,
                    style: const fw.TextStyle(
                      fontSize: 14,
                      fontWeight: fw.FontWeight.w600,
                    ),
                  ),
                  const fw.SizedBox(height: 2),
                  fw.Text(
                    product.category?.name ?? '',
                    maxLines: 1,
                    overflow: fw.TextOverflow.ellipsis,
                    style: fw.TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                  const fw.SizedBox(height: 4),
                  fw.Row(
                    mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
                    children: [
                      fw.Text(
                        '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: fw.TextStyle(
                          fontSize: 16,
                          fontWeight: fw.FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      fw.Container(
                        padding: const fw.EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: fw.BoxDecoration(
                          color: (product.totalStockQuantity ?? 0) > 0
                              ? AppDesignTokens.successColor.withValues(
                                  alpha: 0.12,
                                )
                              : theme.colorScheme.muted.withValues(alpha: 0.5),
                          borderRadius: fw.BorderRadius.circular(6),
                        ),
                        child: fw.Text(
                          '${product.totalStockQuantity ?? 0}',
                          style: fw.TextStyle(
                            fontSize: 11,
                            fontWeight: fw.FontWeight.w600,
                            color: (product.totalStockQuantity ?? 0) > 0
                                ? AppDesignTokens.successColor
                                : theme.colorScheme.mutedForeground,
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
      ),
    );
  }
}

/// Product Card Skeleton for Home Screen
class _ProductCardSkeleton extends fw.StatelessWidget {
  const _ProductCardSkeleton();

  @override
  fw.Widget build(fw.BuildContext context) {
    return Card(
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          // Product Image Skeleton
          fw.Container(
            height: 140,
            decoration: const fw.BoxDecoration(
              color: AppDesignTokens.mutedSurfaceColor,
              borderRadius: fw.BorderRadius.vertical(
                top: fw.Radius.circular(12),
              ),
            ),
          ),
          // Product Info Skeleton
          fw.Padding(
            padding: const fw.EdgeInsets.all(8),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                const AppSkeletonBox(width: 100, height: 14, borderRadius: 6),
                const fw.SizedBox(height: 2),
                const AppSkeletonBox(width: 70, height: 12, borderRadius: 6),
                const fw.SizedBox(height: 4),
                fw.Row(
                  mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
                  children: [
                    const AppSkeletonBox(
                      width: 60,
                      height: 16,
                      borderRadius: 6,
                    ),
                    const AppSkeletonBox(
                      width: 30,
                      height: 18,
                      borderRadius: 6,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
