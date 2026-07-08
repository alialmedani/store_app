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
              action: fw.GestureDetector(
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CreateProductScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: fw.Container(
                  width: AppDesignTokens.headerActionButtonSize,
                  height: AppDesignTokens.headerActionButtonSize,
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.mutedSurfaceColor,
                    borderRadius: fw.BorderRadius.circular(12),
                  ),
                  child: fw.Center(
                    child: fw.Icon(
                      Icons.add,
                      size: 20,
                      color: Theme.of(context).colorScheme.foreground,
                    ),
                  ),
                ),
              ),
            ),
            fw.Expanded(
              child: PaginationList<ProductModel>(
                withPagination: true,
                withRefresh: true,
                loadingWidget: fw.ListView.builder(
                  padding: const fw.EdgeInsets.fromLTRB(
                    AppDesignTokens.screenPaddingHorizontal,
                    AppDesignTokens.screenPaddingHorizontal,
                    AppDesignTokens.screenPaddingHorizontal,
                    AppDesignTokens.screenPaddingHorizontal,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const fw.Padding(
                      padding: fw.EdgeInsets.only(
                        bottom: AppDesignTokens.cardGap,
                      ),
                      child: ProductCardSkeleton(),
                    );
                  },
                ),
                repositoryCallBack: (data) {
                  return context.read<ProductCubit>().fetchProductList(data);
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
                          metaItems: metaItems.isNotEmpty ? metaItems : null,
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
                                  child: UpdateProductScreen(product: product),
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
          ],
        ),
      ),
    );
  }
}

/// Product Card Widget
 