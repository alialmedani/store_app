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
        // Categories Horizontal List
        SliverToBoxAdapter(
          child: fw.SizedBox(
            height: 160,
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
                    padding: fw.EdgeInsets.only(right: index < 4 ? 14 : 0),
                    child: const _CategoryCardSkeleton(),
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
                        right: index < categories.length - 1 ? 14 : 0,
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

/// Category Card Skeleton
class _CategoryCardSkeleton extends fw.StatelessWidget {
  const _CategoryCardSkeleton();

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Container(
      width: 220,
      height: 150,
      decoration: fw.BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: fw.BorderRadius.circular(26),
        border: fw.Border.all(
          color: theme.colorScheme.border.withValues(alpha: 0.12),
        ),
      ),
      child: fw.ClipRRect(
        borderRadius: fw.BorderRadius.circular(26),
        child: fw.Stack(
          children: [
            const fw.Positioned.fill(
              child: AppSkeletonBox(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 0,
              ),
            ),
            fw.Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: fw.Column(
                crossAxisAlignment: fw.CrossAxisAlignment.start,
                mainAxisSize: fw.MainAxisSize.min,
                children: const [
                  AppSkeletonBox(width: 120, height: 18, borderRadius: 8),
                  fw.SizedBox(height: 8),
                  AppSkeletonBox(width: 100, height: 24, borderRadius: 999),
                ],
              ),
            ),
          ],
        ),
      ),
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
        width: 220,
        height: 150,
        decoration: fw.BoxDecoration(
          borderRadius: fw.BorderRadius.circular(26),
          boxShadow: [
            fw.BoxShadow(
              color: fw.Color(0xFF000000).withValues(alpha: 0.10),
              blurRadius: 28,
              offset: const fw.Offset(0, 16),
            ),
          ],
        ),
        child: fw.ClipRRect(
          borderRadius: fw.BorderRadius.circular(26),
          child: fw.Stack(
            children: [
              fw.Positioned.fill(
                child: AuthenticatedImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: fw.BoxFit.cover,
                  errorWidget: fw.Container(
                    decoration: fw.BoxDecoration(
                      gradient: fw.LinearGradient(
                        begin: fw.Alignment.topLeft,
                        end: fw.Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.20),
                          theme.colorScheme.primary.withValues(alpha: 0.06),
                          theme.colorScheme.card,
                        ],
                      ),
                    ),
                    child: fw.Center(
                      child: fw.Icon(
                        Icons.category_rounded,
                        size: 52,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),

              // Image luxury overlay
              fw.Positioned.fill(
                child: fw.Container(
                  decoration: fw.BoxDecoration(
                    gradient: fw.LinearGradient(
                      begin: fw.Alignment.topCenter,
                      end: fw.Alignment.bottomCenter,
                      colors: [
                        fw.Color(0xFF000000).withValues(alpha: 0.05),
                        fw.Color(0xFF000000).withValues(alpha: 0.22),
                        fw.Color(0xFF000000).withValues(alpha: 0.58),
                      ],
                    ),
                  ),
                ),
              ),

              // Soft side glow
              fw.Positioned(
                top: -35,
                right: -30,
                child: fw.Container(
                  width: 100,
                  height: 100,
                  decoration: fw.BoxDecoration(
                    shape: fw.BoxShape.circle,
                    color: theme.colorScheme.primary.withValues(alpha: 0.22),
                  ),
                ),
              ),

              // Arrow
              fw.Positioned(
                top: 12,
                right: 12,
                child: fw.Container(
                  width: 34,
                  height: 34,
                  decoration: fw.BoxDecoration(
                    color: fw.Color(0xFFFFFFFF).withValues(alpha: 0.88),
                    borderRadius: fw.BorderRadius.circular(999),
                    border: fw.Border.all(
                      color: fw.Color(0xFFFFFFFF).withValues(alpha: 0.45),
                    ),
                  ),
                  child: fw.Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              // Text
              fw.Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  mainAxisSize: fw.MainAxisSize.min,
                  children: [
                    fw.Text(
                      category.name ?? 'Unknown',
                      maxLines: 1,
                      overflow: fw.TextOverflow.ellipsis,
                      style: const fw.TextStyle(
                        fontSize: 18,
                        height: 1.05,
                        fontWeight: fw.FontWeight.w900,
                        letterSpacing: -0.4,
                        color: fw.Color(0xFFFFFFFF),
                      ),
                    ),
                    const fw.SizedBox(height: 6),
                    fw.Container(
                      padding: const fw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: fw.BoxDecoration(
                        color: fw.Color(0xFFFFFFFF).withValues(alpha: 0.18),
                        borderRadius: fw.BorderRadius.circular(999),
                        border: fw.Border.all(
                          color: fw.Color(0xFFFFFFFF).withValues(alpha: 0.22),
                        ),
                      ),
                      child: const fw.Text(
                        'Explore collection',
                        maxLines: 1,
                        overflow: fw.TextOverflow.ellipsis,
                        style: fw.TextStyle(
                          fontSize: 11.5,
                          fontWeight: fw.FontWeight.w700,
                          color: fw.Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
