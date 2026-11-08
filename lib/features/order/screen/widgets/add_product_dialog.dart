import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../category/cubit/category_cubit.dart';
import '../../../category/data/model/category_model.dart';
import '../../../product/cubit/product_cubit.dart';
import '../../../product/data/model/product_model.dart';
import '../../../product_variant/cubit/product_variant_cubit.dart';
import '../../../product_variant/data/model/product_variant_model.dart';
import 'package:easy_localization/easy_localization.dart';

/// Smart Add Product Dialog - Multiple ways to add products to order
/// - Browse by Category
/// - Browse all Products
/// - Browse all Variants
class AddProductDialog extends fw.StatefulWidget {
  final Function(String productVariantId, int quantity) onItemAdded;

  const AddProductDialog({super.key, required this.onItemAdded});

  @override
  fw.State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends fw.State<AddProductDialog> {
  int _selectedTabIndex = 0;
  String? selectedVariantId;
  String? selectedCategoryId;
  String? selectedProductId;
  final _quantityController = fw.TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text('add_product_to_order'.tr()),
      content: fw.SizedBox(
        width: 450,
        height: 500,
        child: fw.Column(
          crossAxisAlignment: fw.CrossAxisAlignment.stretch,
          children: [
            // Tab Selection
            fw.Container(
              padding: const fw.EdgeInsets.all(4),
              decoration: fw.BoxDecoration(
                color: theme.colorScheme.muted.withValues(alpha: 0.3),
                borderRadius: fw.BorderRadius.circular(12),
              ),
              child: fw.Row(
                children: [
                  _TabButton(
                    label: 'by_category'.tr(),
                    isSelected: _selectedTabIndex == 0,
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 0;
                        selectedVariantId = null;
                        selectedProductId = null;
                      });
                    },
                  ),
                  const fw.SizedBox(width: 4),
                  _TabButton(
                    label: 'by_product'.tr(),
                    isSelected: _selectedTabIndex == 1,
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 1;
                        selectedVariantId = null;
                        selectedCategoryId = null;
                      });
                    },
                  ),
                  const fw.SizedBox(width: 4),
                  _TabButton(
                    label: 'all_variants'.tr(),
                    isSelected: _selectedTabIndex == 2,
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 2;
                        selectedCategoryId = null;
                        selectedProductId = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            const fw.SizedBox(height: 16),

            // Tab Content
            fw.Expanded(
              child: _selectedTabIndex == 0
                  ? _ByCategoryView(
                      selectedCategoryId: selectedCategoryId,
                      selectedProductId: selectedProductId,
                      selectedVariantId: selectedVariantId,
                      onCategorySelected: (id) {
                        setState(() {
                          selectedCategoryId = id;
                          selectedProductId = null;
                          selectedVariantId = null;
                        });
                      },
                      onProductSelected: (id) {
                        setState(() {
                          selectedProductId = id;
                          selectedVariantId = null;
                        });
                      },
                      onVariantSelected: (id) {
                        setState(() {
                          selectedVariantId = id;
                        });
                      },
                    )
                  : _selectedTabIndex == 1
                      ? _ByProductView(
                          selectedProductId: selectedProductId,
                          selectedVariantId: selectedVariantId,
                          onProductSelected: (id) {
                            setState(() {
                              selectedProductId = id;
                              selectedVariantId = null;
                            });
                          },
                          onVariantSelected: (id) {
                            setState(() {
                              selectedVariantId = id;
                            });
                          },
                        )
                      : _AllVariantsView(
                          selectedVariantId: selectedVariantId,
                          onVariantSelected: (id) {
                            setState(() {
                              selectedVariantId = id;
                            });
                          },
                        ),
            ),
            const fw.SizedBox(height: 16),

            // Quantity Field
            Text(
              'quantity_2'.tr(),
              style: fw.TextStyle(fontSize: 14, fontWeight: fw.FontWeight.w600),
            ),
            const fw.SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              placeholder: Text('enter_quantity'.tr()),
              keyboardType: const fw.TextInputType.numberWithOptions(
                decimal: false,
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlineButton(
          onPressed: () => fw.Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        PrimaryButton(
          onPressed: () {
            if (selectedVariantId == null) {
              _showError(context, 'please_select_a_product_variant'.tr());
              return;
            }

            final quantity = int.tryParse(_quantityController.text) ?? 1;
            if (quantity <= 0) {
              _showError(context, 'quantity_must_be_greater_than_0'.tr());
              return;
            }

            widget.onItemAdded(selectedVariantId!, quantity);
            fw.Navigator.pop(context);
          },
          child: Text('add_to_order'.tr()),
        ),
      ],
    );
  }

  void _showError(fw.BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('error_2'.tr()),
        content: Text(message),
        actions: [
          PrimaryButton(
            onPressed: () => fw.Navigator.pop(ctx),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }
}

/// Tab Button Widget
class _TabButton extends fw.StatelessWidget {
  final String label;
  final bool isSelected;
  final fw.VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Expanded(
      child: fw.GestureDetector(
        onTap: onTap,
        child: fw.Container(
          padding: const fw.EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: fw.BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : null,
            borderRadius: fw.BorderRadius.circular(8),
          ),
          child: fw.Center(
            child: Text(
              label,
              style: fw.TextStyle(
                fontSize: 13,
                fontWeight: fw.FontWeight.w600,
                color: isSelected
                    ? theme.colorScheme.primaryForeground
                    : theme.colorScheme.foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// By Category View - Browse categories → products → variants
class _ByCategoryView extends fw.StatelessWidget {
  final String? selectedCategoryId;
  final String? selectedProductId;
  final String? selectedVariantId;
  final Function(String) onCategorySelected;
  final Function(String) onProductSelected;
  final Function(String) onVariantSelected;

  const _ByCategoryView({
    required this.selectedCategoryId,
    required this.selectedProductId,
    required this.selectedVariantId,
    required this.onCategorySelected,
    required this.onProductSelected,
    required this.onVariantSelected,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.stretch,
      children: [
        // Step 1: Select Category
        Text(
          '1_select_category'.tr(),
          style: fw.TextStyle(
            fontSize: 13,
            fontWeight: fw.FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const fw.SizedBox(height: 8),
        fw.SizedBox(
          height: 120,
          child: BlocProvider(
            create: (_) => CategoryCubit(),
            child: PaginationList<CategoryModel>(
              withPagination: false,
              withRefresh: false,
              loadingWidget: const ChipsRowSkeleton(width: 140),
repositoryCallBack: (data) {
                return context.read<CategoryCubit>().fetchCategoryList(data);
              },
              listBuilder: (list) {
                return fw.ListView.builder(
                  scrollDirection: fw.Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final category = list[index];
                    final isSelected = selectedCategoryId == category.id;

                    return fw.GestureDetector(
                      onTap: () {
                        if (category.id != null) {
                          onCategorySelected(category.id!);
                        }
                      },
                      child: fw.Container(
                        width: 140,
                        margin: const fw.EdgeInsetsDirectional.only(end: 8),
                        padding: const fw.EdgeInsets.all(12),
                        decoration: fw.BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.15)
                              : theme.colorScheme.muted.withValues(alpha: 0.3),
                          borderRadius: fw.BorderRadius.circular(12),
                          border: fw.Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.border.withValues(alpha: 0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: fw.Column(
                          crossAxisAlignment: fw.CrossAxisAlignment.start,
                          mainAxisAlignment: fw.MainAxisAlignment.center,
                          children: [
                            Text(
                              category.name ?? 'N/A',
                              style: fw.TextStyle(
                                fontSize: 14,
                                fontWeight: fw.FontWeight.w600,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.foreground,
                              ),
                              maxLines: 2,
                              overflow: fw.TextOverflow.ellipsis,
                            ),
                            if (category.description != null &&
                                category.description!.isNotEmpty) ...[
                              const fw.SizedBox(height: 4),
                              Text(
                                category.description!,
                                style: fw.TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                                maxLines: 2,
                                overflow: fw.TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const fw.SizedBox(height: 16),

        // Step 2: Select Product from Category
        if (selectedCategoryId != null) ...[
          Text(
            '2_select_product'.tr(),
            style: fw.TextStyle(
              fontSize: 13,
              fontWeight: fw.FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const fw.SizedBox(height: 8),
          fw.SizedBox(
            height: 100,
            child: BlocProvider(
              create: (_) => ProductCubit(),
              child: PaginationList<ProductModel>(
                withPagination: false,
                withRefresh: false,
                loadingWidget: const ChipsRowSkeleton(width: 120),
repositoryCallBack: (data) {
                  return context.read<ProductCubit>().fetchProductList(
                    data,
                    categoryId: selectedCategoryId,
                  );
                },
                listBuilder: (list) {
                  if (list.isEmpty) {
                    return fw.Center(
                      child: Text(
                        'no_products_in_this_category'.tr(),
                        style: fw.TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    );
                  }

                  return fw.ListView.builder(
                    scrollDirection: fw.Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final product = list[index];
                      final isSelected = selectedProductId == product.id;

                      return fw.GestureDetector(
                        onTap: () {
                          if (product.id != null) {
                            onProductSelected(product.id!);
                          }
                        },
                        child: fw.Container(
                          width: 120,
                          margin: const fw.EdgeInsetsDirectional.only(end: 8),
                          padding: const fw.EdgeInsets.all(10),
                          decoration: fw.BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary.withValues(alpha: 0.15)
                                : theme.colorScheme.muted.withValues(alpha: 0.3),
                            borderRadius: fw.BorderRadius.circular(10),
                            border: fw.Border.all(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.border.withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: fw.Center(
                            child: Text(
                              product.name ?? 'N/A',
                              style: fw.TextStyle(
                                fontSize: 13,
                                fontWeight: fw.FontWeight.w600,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.foreground,
                              ),
                              textAlign: fw.TextAlign.center,
                              maxLines: 2,
                              overflow: fw.TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const fw.SizedBox(height: 16),
        ],

        // Step 3: Select Variant
        if (selectedProductId != null) ...[
          Text(
            '3_select_variant'.tr(),
            style: fw.TextStyle(
              fontSize: 13,
              fontWeight: fw.FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const fw.SizedBox(height: 8),
          fw.Expanded(
            child: BlocProvider(
              create: (_) => ProductVariantCubit(),
              child: PaginationList<ProductVariantModel>(
                withPagination: false,
                withRefresh: false,
                loadingWidget: const SelectorListSkeleton(withSubtitle: false),
repositoryCallBack: (data) {
                  return context
                      .read<ProductVariantCubit>()
                      .fetchProductVariantList(data, productId: selectedProductId);
                },
                listBuilder: (list) {
                  if (list.isEmpty) {
                    return fw.Center(
                      child: Text(
                        'no_variants_for_this_product'.tr(),
                        style: fw.TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    );
                  }

                  return fw.ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final variant = list[index];
                      final isSelected = selectedVariantId == variant.id;

                      return fw.GestureDetector(
                        onTap: () {
                          if (variant.id != null) {
                            onVariantSelected(variant.id!);
                          }
                        },
                        child: fw.Container(
                          margin: const fw.EdgeInsets.only(bottom: 8),
                          padding: const fw.EdgeInsets.all(12),
                          decoration: fw.BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary.withValues(alpha: 0.15)
                                : theme.colorScheme.muted.withValues(alpha: 0.3),
                            borderRadius: fw.BorderRadius.circular(10),
                            border: fw.Border.all(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.border.withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: fw.Row(
                            children: [
                              fw.Expanded(
                                child: fw.Column(
                                  crossAxisAlignment:
                                      fw.CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'color_size'.tr(args: ['${variant.color ?? 'N/A'}', '${variant.size ?? 'N/A'}']),
                                      style: fw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: fw.FontWeight.w600,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.foreground,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 4),
                                    Text(
                                      'stock'.tr(args: ['${variant.stockQuantity ?? 0}']),
                                      style: fw.TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// By Product View - Browse products → variants
class _ByProductView extends fw.StatelessWidget {
  final String? selectedProductId;
  final String? selectedVariantId;
  final Function(String) onProductSelected;
  final Function(String) onVariantSelected;

  const _ByProductView({
    required this.selectedProductId,
    required this.selectedVariantId,
    required this.onProductSelected,
    required this.onVariantSelected,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.stretch,
      children: [
        // Step 1: Select Product
        Text(
          '1_select_product'.tr(),
          style: fw.TextStyle(
            fontSize: 13,
            fontWeight: fw.FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const fw.SizedBox(height: 8),
        fw.SizedBox(
          height: 150,
          child: BlocProvider(
            create: (_) => ProductCubit(),
            child: PaginationList<ProductModel>(
              withPagination: true,
              withRefresh: false,
              loadingWidget: const SelectorListSkeleton(withSubtitle: false),
repositoryCallBack: (data) {
                return context.read<ProductCubit>().fetchProductList(data);
              },
              listBuilder: (list) {
                return fw.ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final product = list[index];
                    final isSelected = selectedProductId == product.id;

                    return fw.GestureDetector(
                      onTap: () {
                        if (product.id != null) {
                          onProductSelected(product.id!);
                        }
                      },
                      child: fw.Container(
                        margin: const fw.EdgeInsets.only(bottom: 8),
                        padding: const fw.EdgeInsets.all(12),
                        decoration: fw.BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.15)
                              : theme.colorScheme.muted.withValues(alpha: 0.3),
                          borderRadius: fw.BorderRadius.circular(10),
                          border: fw.Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.border.withValues(alpha: 0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: fw.Row(
                          children: [
                            fw.Expanded(
                              child: Text(
                                product.name ?? 'N/A',
                                style: fw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: fw.FontWeight.w600,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.foreground,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const fw.SizedBox(height: 16),

        // Step 2: Select Variant
        if (selectedProductId != null) ...[
          Text(
            '2_select_variant'.tr(),
            style: fw.TextStyle(
              fontSize: 13,
              fontWeight: fw.FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const fw.SizedBox(height: 8),
          fw.Expanded(
            child: BlocProvider(
              create: (_) => ProductVariantCubit(),
              child: PaginationList<ProductVariantModel>(
                withPagination: false,
                withRefresh: false,
                loadingWidget: const SelectorListSkeleton(withSubtitle: false),
repositoryCallBack: (data) {
                  return context
                      .read<ProductVariantCubit>()
                      .fetchProductVariantList(data, productId: selectedProductId);
                },
                listBuilder: (list) {
                  if (list.isEmpty) {
                    return fw.Center(
                      child: Text(
                        'no_variants_for_this_product'.tr(),
                        style: fw.TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    );
                  }

                  return fw.ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final variant = list[index];
                      final isSelected = selectedVariantId == variant.id;

                      return fw.GestureDetector(
                        onTap: () {
                          if (variant.id != null) {
                            onVariantSelected(variant.id!);
                          }
                        },
                        child: fw.Container(
                          margin: const fw.EdgeInsets.only(bottom: 8),
                          padding: const fw.EdgeInsets.all(12),
                          decoration: fw.BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary.withValues(alpha: 0.15)
                                : theme.colorScheme.muted.withValues(alpha: 0.3),
                            borderRadius: fw.BorderRadius.circular(10),
                            border: fw.Border.all(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.border.withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: fw.Row(
                            children: [
                              fw.Expanded(
                                child: fw.Column(
                                  crossAxisAlignment:
                                      fw.CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'color_size'.tr(args: ['${variant.color ?? 'N/A'}', '${variant.size ?? 'N/A'}']),
                                      style: fw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: fw.FontWeight.w600,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.foreground,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 4),
                                    Text(
                                      'stock'.tr(args: ['${variant.stockQuantity ?? 0}']),
                                      style: fw.TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// All Variants View - Browse all variants directly
class _AllVariantsView extends fw.StatelessWidget {
  final String? selectedVariantId;
  final Function(String) onVariantSelected;

  const _AllVariantsView({
    required this.selectedVariantId,
    required this.onVariantSelected,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.stretch,
      children: [
        Text(
          'select_variant'.tr(),
          style: fw.TextStyle(
            fontSize: 13,
            fontWeight: fw.FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const fw.SizedBox(height: 8),
        fw.Expanded(
          child: BlocProvider(
            create: (_) => ProductVariantCubit(),
            child: PaginationList<ProductVariantModel>(
              withPagination: true,
              withRefresh: false,
              loadingWidget: const SelectorListSkeleton(withSubtitle: false),
repositoryCallBack: (data) {
                return context
                    .read<ProductVariantCubit>()
                    .fetchProductVariantList(data);
              },
              listBuilder: (list) {
                return fw.ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final variant = list[index];
                    final isSelected = selectedVariantId == variant.id;

                    return fw.GestureDetector(
                      onTap: () {
                        if (variant.id != null) {
                          onVariantSelected(variant.id!);
                        }
                      },
                      child: fw.Container(
                        margin: const fw.EdgeInsets.only(bottom: 8),
                        padding: const fw.EdgeInsets.all(12),
                        decoration: fw.BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.15)
                              : theme.colorScheme.muted.withValues(alpha: 0.3),
                          borderRadius: fw.BorderRadius.circular(10),
                          border: fw.Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.border.withValues(alpha: 0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: fw.Row(
                          children: [
                            fw.Expanded(
                              child: fw.Column(
                                crossAxisAlignment: fw.CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    variant.productName ?? 'N/A',
                                    style: fw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: fw.FontWeight.w700,
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.foreground,
                                    ),
                                  ),
                                  const fw.SizedBox(height: 4),
                                  Text(
                                    'color_size'.tr(args: ['${variant.color ?? 'N/A'}', '${variant.size ?? 'N/A'}']),
                                    style: fw.TextStyle(
                                      fontSize: 13,
                                      fontWeight: fw.FontWeight.w600,
                                      color: theme.colorScheme.foreground,
                                    ),
                                  ),
                                  const fw.SizedBox(height: 4),
                                  Text(
                                    'stock'.tr(args: ['${variant.stockQuantity ?? 0}']),
                                    style: fw.TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
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
