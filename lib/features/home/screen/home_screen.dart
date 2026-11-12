import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../../core/ui/widgets/authenticated_image.dart';
import '../../../core/utils/image_helper.dart';
import '../../category/cubit/category_cubit.dart';
import '../../category/data/model/category_model.dart';
import '../../category/screen/category_list_screen.dart';
import '../../product/cubit/product_cubit.dart';
import '../../product/data/model/product_model.dart';
import '../../product/screen/product_details_screen.dart';
import '../../product/screen/product_list_screen.dart';
import 'package:easy_localization/easy_localization.dart';

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
          child: AppTabHeader(
            title: 'discover'.tr(),
            subtitle: 'browse_products_categories'.tr(),
            icon: Icons.shopping_bag_rounded,
          ),
        ),

        // Editorial promo banner (serif-italic display headline, ember CTA)
        SliverToBoxAdapter(
          child: fw.Padding(
            padding: const fw.EdgeInsets.fromLTRB(
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.smallGap,
              AppDesignTokens.screenPaddingHorizontal,
              0,
            ),
            child: AppPromoBanner(
              eyebrow: 'promo_eyebrow'.tr(),
              headline: 'promo_headline'.tr(),
              ctaLabel: 'discover_now'.tr(),
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
                        gradient: AppDesignTokens.primaryGradient,
                        borderRadius: fw.BorderRadius.circular(1.5),
                      ),
                    ),
                    const fw.SizedBox(width: AppDesignTokens.itemGap),
                    fw.Text(
                      'categories'.tr(),
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
                        pageBuilder: (_, __, ___) => const CategoryListScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: fw.Text(
                    'see_all'.tr(),
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

        // Categories Horizontal List
        // Categories Horizontal List
        SliverToBoxAdapter(
          child: fw.SizedBox(
            height: 150,
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
                    padding: fw.EdgeInsetsDirectional.only(end: index < 4 ? 14 : 0),
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
                      padding: fw.EdgeInsetsDirectional.only(
                        end: index < categories.length - 1 ? 14 : 0,
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
                        gradient: AppDesignTokens.primaryGradient,
                        borderRadius: fw.BorderRadius.circular(1.5),
                      ),
                    ),
                    const fw.SizedBox(width: AppDesignTokens.itemGap),
                    fw.Text(
                      'products'.tr(),
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
                    'see_all'.tr(),
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
            height: 3 * 276 + 2 * 12 + AppDesignTokens.sectionGap + 8,
            child: PaginationList<ProductModel>(
              loadingWidget: fw.GridView.builder(
                padding: const fw.EdgeInsets.fromLTRB(
                  AppDesignTokens.screenPaddingHorizontal,
                  0,
                  AppDesignTokens.screenPaddingHorizontal,
                  AppDesignTokens.sectionGap,
                ),
                physics: const fw.NeverScrollableScrollPhysics(),
                gridDelegate:
                    const fw.SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 276,
                    ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const _ProductCardSkeleton();
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
                    AppDesignTokens.sectionGap,
                  ),
                  physics: const fw.NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const fw.SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 276,
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

/// Category Card Skeleton - same geometry as [_CategoryCard]
class _CategoryCardSkeleton extends fw.StatelessWidget {
  const _CategoryCardSkeleton();

  @override
  fw.Widget build(fw.BuildContext context) {
    return const fw.SizedBox(
      width: _CategoryCard.itemWidth,
      child: fw.Column(
        children: [
          AppSkeletonBox(width: _CategoryCard.circle, height: _CategoryCard.circle, borderRadius: _CategoryCard.circle / 2),
          fw.SizedBox(height: 10),
          AppSkeletonBox(width: 64, height: 13, borderRadius: 6),
          fw.SizedBox(height: 6),
          AppSkeletonBox(width: 48, height: 11, borderRadius: 6),
        ],
      ),
    );
  }
}

/// Category Card Widget - ember circle with the category initial, name below
class _CategoryCard extends fw.StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({required this.category});

  static const double itemWidth = 96;
  static const double circle = 84;

  @override
  fw.Widget build(fw.BuildContext context) {
    final name = (category.name ?? '').trim();
    final initial = name.isEmpty ? '#' : name.substring(0, 1).toUpperCase();

    return fw.GestureDetector(
      onTap: () {
        fw.Navigator.push(
          context,
          fw.PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProductListScreen(
              categoryId: category.id,
              categoryName: category.name,
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: fw.SizedBox(
        width: itemWidth,
        child: fw.Column(
          children: [
            fw.Container(
              width: circle,
              height: circle,
              alignment: fw.Alignment.center,
              decoration: fw.BoxDecoration(
                gradient: AppDesignTokens.primaryGradient,
                shape: fw.BoxShape.circle,
                boxShadow: AppDesignTokens.glowShadow,
                border: fw.Border.all(
                  color: const fw.Color(0xFFFFFFFF).withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: fw.Stack(
                alignment: fw.Alignment.center,
                children: [
                  fw.Positioned(
                    top: -18,
                    right: -10,
                    child: fw.Container(
                      width: 56,
                      height: 56,
                      decoration: fw.BoxDecoration(
                        shape: fw.BoxShape.circle,
                        color: const fw.Color(0xFFFFFFFF).withValues(alpha: 0.16),
                      ),
                    ),
                  ),
                  fw.Text(
                    initial,
                    style: const fw.TextStyle(
                      fontSize: 30,
                      fontWeight: fw.FontWeight.w800,
                      color: fw.Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            const fw.SizedBox(height: 10),
            fw.Text(
              category.name ?? 'unknown'.tr(),
              maxLines: 1,
              textAlign: fw.TextAlign.center,
              overflow: fw.TextOverflow.ellipsis,
              style: fw.TextStyle(
                fontSize: 13.5,
                fontWeight: fw.FontWeight.w700,
                color: AppDesignTokens.titleTextColor,
              ),
            ),
            const fw.SizedBox(height: 2),
            fw.Text(
              'explore_collection'.tr(),
              maxLines: 1,
              textAlign: fw.TextAlign.center,
              overflow: fw.TextOverflow.ellipsis,
              style: fw.TextStyle(
                fontSize: 11.5,
                color: AppDesignTokens.mutedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product Card Widget - flat paper/ink card
class _ProductCard extends fw.StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  fw.Widget build(fw.BuildContext context) {
    final imageUrl = ImageHelper.getProductImageUrl(product.id ?? '');
    final stock = product.totalStockQuantity ?? 0;
    final inStock = stock > 0;
    final stockColor = inStock
        ? AppDesignTokens.successColor
        : AppDesignTokens.mutedTextColor;

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
      child: fw.Container(
        padding: const fw.EdgeInsets.all(8),
        decoration: AppDesignTokens.glassDecoration(),
        child: fw.Column(
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            fw.Expanded(
              child: fw.Stack(
                children: [
                  fw.Positioned.fill(
                    child: fw.ClipRRect(
                      borderRadius: fw.BorderRadius.circular(
                        AppDesignTokens.cardRadius - 8,
                      ),
                      child: AuthenticatedImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: fw.BoxFit.cover,
                        errorWidget: fw.Container(
                          decoration: fw.BoxDecoration(
                            color: AppDesignTokens.mutedSurfaceColor,
                          ),
                          child: fw.Center(
                            child: fw.Icon(
                              Icons.inventory_2_rounded,
                              size: 40,
                              color: AppDesignTokens.mutedTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  fw.Positioned(
                    top: 8,
                    left: 8,
                    child: fw.Container(
                      padding: const fw.EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: fw.BoxDecoration(
                        color: AppDesignTokens.cardColor.withValues(alpha: 0.88),
                        borderRadius: fw.BorderRadius.circular(
                          AppDesignTokens.badgeRadius,
                        ),
                      ),
                      child: fw.Row(
                        mainAxisSize: fw.MainAxisSize.min,
                        children: [
                          fw.Container(
                            width: 6,
                            height: 6,
                            decoration: fw.BoxDecoration(
                              color: stockColor,
                              shape: fw.BoxShape.circle,
                            ),
                          ),
                          const fw.SizedBox(width: 5),
                          fw.Text(
                            '$stock',
                            style: fw.TextStyle(
                              fontSize: 11.5,
                              fontWeight: fw.FontWeight.w700,
                              color: stockColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            fw.Padding(
              padding: const fw.EdgeInsets.fromLTRB(6, 10, 6, 4),
              child: fw.Column(
                crossAxisAlignment: fw.CrossAxisAlignment.start,
                children: [
                  fw.Text(
                    product.name ?? 'unknown'.tr(),
                    maxLines: 1,
                    overflow: fw.TextOverflow.ellipsis,
                    style: fw.TextStyle(
                      fontSize: 14,
                      fontWeight: fw.FontWeight.w700,
                      color: AppDesignTokens.titleTextColor,
                    ),
                  ),
                  const fw.SizedBox(height: 2),
                  fw.Text(
                    product.category?.name ?? '',
                    maxLines: 1,
                    overflow: fw.TextOverflow.ellipsis,
                    style: fw.TextStyle(
                      fontSize: 12,
                      color: AppDesignTokens.mutedTextColor,
                    ),
                  ),
                  const fw.SizedBox(height: 8),
                  fw.Container(
                    padding: const fw.EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: fw.BoxDecoration(
                      gradient: AppDesignTokens.primaryGradient,
                      borderRadius: fw.BorderRadius.circular(
                        AppDesignTokens.badgeRadius,
                      ),
                    ),
                    child: fw.Text(
                      '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: const fw.TextStyle(
                        fontSize: 13.5,
                        fontWeight: fw.FontWeight.w800,
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
    );
  }
}

/// Product Card Skeleton - same geometry as [_ProductCard]
class _ProductCardSkeleton extends fw.StatelessWidget {
  const _ProductCardSkeleton();

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(8),
      decoration: AppDesignTokens.glassDecoration(),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: const [
          fw.Expanded(
            child: AppSkeletonBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: AppDesignTokens.cardRadius - 8,
            ),
          ),
          fw.Padding(
            padding: fw.EdgeInsets.fromLTRB(6, 10, 6, 4),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                AppSkeletonBox(width: 100, height: 14, borderRadius: 6),
                fw.SizedBox(height: 4),
                AppSkeletonBox(width: 70, height: 12, borderRadius: 6),
                fw.SizedBox(height: 8),
                AppSkeletonBox(width: 64, height: 24, borderRadius: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
