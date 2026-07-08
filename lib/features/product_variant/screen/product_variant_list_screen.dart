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
              onBack: () => fw.Navigator.of(context).pop(),
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
                      AppDesignTokens.listBottomPadding,
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
                              fw.Navigator.of(context).push(
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
                            fw.Navigator.of(context).push(
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
            StickyBottomAction(
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
                leading: const fw.Icon(Icons.add, size: 20),
                child: const Text(
                  'Add Variant',
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
