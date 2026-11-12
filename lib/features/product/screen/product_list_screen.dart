import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../../core/boilerplate/pagination/cubits/pagination_cubit.dart';
import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/utils/image_helper.dart';
import '../../category/screen/category_details_screen.dart';
import '../cubit/product_cubit.dart';
import '../data/model/product_model.dart';
import 'create_product_screen.dart';
import 'product_details_screen.dart';
import 'update_product_screen.dart';
import 'package:easy_localization/easy_localization.dart';

/// Product List Screen - Shows all products with pagination
/// Uses PaginationList widget from boilerplate
class ProductListScreen extends fw.StatefulWidget {
  /// When set, only the products of this category are listed
  final String? categoryId;
  final String? categoryName;

  const ProductListScreen({super.key, this.categoryId, this.categoryName});

  @override
  fw.State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends fw.State<ProductListScreen> {
  PaginationCubit? _listCubit;

  /// Reload the first page (after returning from details / edit / create)
  void _reloadList() {
    _listCubit?.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: SafeArea(
        child: ScrollAwayHeader(header: fw.Column(children: [
            AppHeader(
              title: widget.categoryName ?? 'products'.tr(),
              onBack: () => fw.Navigator.pop(context),
              action: fw.Row(
                mainAxisSize: fw.MainAxisSize.min,
                children: [
                  if (widget.categoryId != null) ...[
                    IconButton(
                      icon: const fw.Icon(Icons.info_outline_rounded, size: 20),
                      onPressed: () => fw.Navigator.push(
                        context,
                        fw.PageRouteBuilder(
                          pageBuilder: (_, __, ___) => CategoryDetailsScreen(
                            categoryId: widget.categoryId!,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      ),
                      variance: ButtonVariance.ghost,
                    ),
                    const fw.SizedBox(width: 8),
                  ],
                  fw.GestureDetector(
                onTap: () async {
                  await fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CreateProductScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  _reloadList();
                },
                child: fw.Container(
                  width: AppDesignTokens.headerActionButtonSize,
                  height: AppDesignTokens.headerActionButtonSize,
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.mutedSurfaceColor,
                    borderRadius: fw.BorderRadius.circular(AppDesignTokens.iconBoxRadius),
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
                ],
              ),
            )]), body: PaginationList<ProductModel>(
                onCubitCreated: (cubit) => _listCubit = cubit,
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
                noDataWidget: EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'products_empty_title'.tr(),
                  subtitle: 'products_empty_subtitle'.tr(),
                ),
                repositoryCallBack: (data) {
                  return context.read<ProductCubit>().fetchProductList(
                    data,
                    categoryId: widget.categoryId,
                  );
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
                            text: 'stock'.tr(args: ['${product.totalStockQuantity}']),
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
                                ? 'active'.tr()
                                : 'inactive'.tr(),
                            type: (product.isActive ?? false)
                                ? StatusBadgeType.active
                                : StatusBadgeType.inactive,
                          ),
                          metaItems: metaItems.isNotEmpty ? metaItems : null,
                          onTap: () async {
                            if (product.id != null) {
                              await fw.Navigator.push(
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
                            _reloadList();
                          },
                          onEdit: () async {
                            await fw.Navigator.push(
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
                            _reloadList();
                          },
                        ),
                      );
                    },
                  );
                },
              )),
      ),
    );
  }
}

/// Product Card Widget
 