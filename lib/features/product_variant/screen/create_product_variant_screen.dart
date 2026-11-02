import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../product/cubit/product_cubit.dart';
import '../../product/data/model/product_model.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/model/product_variant_model.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

/// Create Product Variant Screen - Form to create new product variant
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class CreateProductVariantScreen extends StatefulWidget {
  final ProductModel? initialProduct;
  const CreateProductVariantScreen({super.key, this.initialProduct});

  @override
  State<CreateProductVariantScreen> createState() =>
      _CreateProductVariantScreenState();
}

class _CreateProductVariantScreenState
    extends State<CreateProductVariantScreen> {
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  final _productIdController = TextEditingController();
  CreateModelCubit? createModelCubit;

  bool _validateFields(ProductVariantCubit cubit) {
    bool isValid = true;

    // Validate product
    if (_productIdController.text.trim().isEmpty) {
      cubit.setProductError('product_is_required'.tr());
      isValid = false;
    } else {
      cubit.clearProductError();
    }

    // Color and Size are always optional - clear any errors
    cubit.clearColorError();
    cubit.clearSizeError();

    // Validate stock quantity
    final stockText = _stockQuantityController.text.trim();
    if (stockText.isEmpty) {
      cubit.setStockQuantityError('stock_quantity_is_required'.tr());
      isValid = false;
    } else {
      final stock = int.tryParse(stockText);
      if (stock == null) {
        cubit.setStockQuantityError('please_enter_a_valid_number'.tr());
        isValid = false;
      } else if (stock < 0) {
        cubit.setStockQuantityError('stock_quantity_must_be_0_or_greater'.tr());
        isValid = false;
      } else {
        cubit.clearStockQuantityError();
      }
    }

    return isValid;
  }

  void _showProductSelector(BuildContext context, ProductVariantCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('select_product'.tr()),
        content: fw.SizedBox(
          width: double.maxFinite,
          height: 400,
          child: PaginationList<ProductModel>(
            withPagination: true,
            withRefresh: true,
            repositoryCallBack: (data) {
              return context.read<ProductCubit>().fetchProductList(data);
            },
            listBuilder: (list) {
              return fw.ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final product = list[index];
                  return fw.GestureDetector(
                    onTap: () {
                      cubit.selectProduct(product);
                      _productIdController.text = product.name ?? '';
                      fw.Navigator.of(dialogContext).pop();
                    },
                    child: Card(
                      child: fw.Padding(
                        padding: const fw.EdgeInsets.all(12),
                        child: fw.Column(
                          crossAxisAlignment: fw.CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (product.description != null &&
                                product.description!.isNotEmpty) ...[
                              const fw.SizedBox(height: 4),
                              Text(
                                product.description!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.mutedForeground,
                                ),
                                maxLines: 2,
                                overflow: fw.TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          SecondaryButton(
            onPressed: () => fw.Navigator.of(dialogContext).pop(),
            child: Text('cancel'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final p = widget.initialProduct;
    if (p != null) {
      _productIdController.text = p.name ?? '';
      fw.WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.read<ProductVariantCubit>().selectProduct(p);
      });
    }
  }

  @override
  void dispose() {
    _colorController.dispose();
    _sizeController.dispose();
    _stockQuantityController.dispose();
    _productIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductVariantCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: ScrollAwayHeader(header: Column(children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => fw.Navigator.of(context).pop(),
                    variance: ButtonVariance.ghost,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'create_product_variant'.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )]), body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Product Selection
                        BlocBuilder<ProductVariantCubit, ProductVariantState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSelectorField(
                                  label: 'product'.tr(),
                                  value: _productIdController.text.isNotEmpty ? _productIdController.text : null,
                                  placeholder: 'select_product_2'.tr(),
                                  onTap: () => _showProductSelector(context, cubit),
                                ),
                                if (cubit.productError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.productError!,
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Color Field
                        BlocBuilder<ProductVariantCubit, ProductVariantState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'color'.tr(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'optional'.tr(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _colorController,
                                  placeholder: Text(
                                    'enter_color_optional'.tr(),
                                  ),
                                  onChanged: (value) {
                                    cubit.createProductVariantParams.color =
                                        value.isEmpty ? null : value;
                                    cubit.clearColorError();
                                  },
                                ),
                                if (cubit.colorError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.colorError!,
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Size Field
                        BlocBuilder<ProductVariantCubit, ProductVariantState>(
                          builder: (context, state) => !cubit.isSizeVisible()
                              ? const SizedBox.shrink()
                              : BlocBuilder<ProductVariantCubit, ProductVariantState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'size'.tr(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'optional'.tr(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _sizeController,
                                  placeholder: Text(
                                    'enter_size_optional'.tr(),
                                  ),
                                  onChanged: (value) {
                                    cubit.createProductVariantParams.size =
                                        value.isEmpty ? null : value;
                                    cubit.clearSizeError();
                                  },
                                ),
                                if (cubit.sizeError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.sizeError!,
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        ),
                        const SizedBox(height: 16),

                        // Stock Quantity Field
                        BlocBuilder<ProductVariantCubit, ProductVariantState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'stock_quantity'.tr(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _stockQuantityController,
                                  placeholder: Text(
                                    'enter_stock_quantity'.tr(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    final stock = int.tryParse(value);
                                    if (stock != null) {
                                      cubit
                                              .createProductVariantParams
                                              .stockQuantity =
                                          stock;
                                    }
                                    cubit.clearStockQuantityError();
                                  },
                                ),
                                if (cubit.stockQuantityError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.stockQuantityError!,
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Is Active Toggle
                        BlocBuilder<ProductVariantCubit, ProductVariantState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'active'.tr(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value:
                                      cubit.createProductVariantParams.isActive,
                                  onChanged: (value) {
                                    cubit.toggleIsActive(value);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                        CreateModel<ProductVariantModel>(
                          withValidation: true,
                          onTap: () {
                            return _validateFields(cubit);
                          },
                          useCaseCallBack: (data) {
                            return cubit.createProductVariant();
                          },
                          onSuccess: (variant) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('success'.tr()),
                                content: Text(
                                  'product_variant_created_successfully'.tr(),
                                ),
                                actions: [
                                  PrimaryButton(
                                    child: Text('ok'.tr()),
                                    onPressed: () {
                                      fw.Navigator.of(ctx).pop();
                                      fw.Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          onError: (error) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('error_2'.tr()),
                                content: Text(error),
                                actions: [
                                  PrimaryButton(
                                    child: Text('ok'.tr()),
                                    onPressed: () => fw.Navigator.of(ctx).pop(),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: PrimaryButton(
                            child: Text('create_product_variant'.tr()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
      ),
    );
  }
}
