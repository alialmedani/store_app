import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
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
    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          children: [
            AppHeader(
              title: 'Product Variants',
              onBack: () => fw.Navigator.pop(context),
              action: fw.GestureDetector(
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          const VariantCreationOptionsScreen(),
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
              child: PaginationList<ProductVariantModel>(
                withPagination: true,
                withRefresh: true,
                repositoryCallBack: (data) {
                  return context
                      .read<ProductVariantCubit>()
                      .fetchProductVariantList(data);
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
                      final variant = list[index];

                      final metaItems = <EntityMetaItem>[];
                      if (variant.color != null && variant.color!.isNotEmpty) {
                        metaItems.add(
                          EntityMetaItem(
                            icon: Icons.palette_outlined,
                            text: variant.color!,
                          ),
                        );
                      }
                      if (variant.size != null && variant.size!.isNotEmpty) {
                        metaItems.add(
                          EntityMetaItem(
                            icon: Icons.straighten,
                            text: variant.size!,
                          ),
                        );
                      }
                      if (variant.stockQuantity != null) {
                        metaItems.add(
                          EntityMetaItem(
                            icon: Icons.inventory_2_outlined,
                            text: 'Stock: ${variant.stockQuantity}',
                          ),
                        );
                      }

                      return fw.Padding(
                        padding: const fw.EdgeInsets.only(
                          bottom: AppDesignTokens.cardGap,
                        ),
                        child: EntityListCard(
                          title: variant.productName ?? 'N/A',
                          statusBadge: variant.isActive != null
                              ? StatusBadge(
                                  text: variant.isActive!
                                      ? 'Active'
                                      : 'Inactive',
                                  type: variant.isActive!
                                      ? StatusBadgeType.active
                                      : StatusBadgeType.inactive,
                                )
                              : null,
                          metaItems: metaItems.isNotEmpty ? metaItems : null,
                          onTap: () {
                            if (variant.id != null) {
                              fw.Navigator.push(
                                context,
                                fw.PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      ProductVariantDetailsScreen(
                                        productVariantId: variant.id!,
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
                                  create: (_) => ProductVariantCubit(),
                                  child: UpdateProductVariantScreen(
                                    variant: variant,
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
          ],
        ),
      ),
    );
  }
}
