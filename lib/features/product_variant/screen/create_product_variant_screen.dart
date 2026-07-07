import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../product/cubit/product_cubit.dart';
import '../../product/data/model/product_model.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/model/product_variant_model.dart';

/// Create Product Variant Screen - Form to create new product variant
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class CreateProductVariantScreen extends StatefulWidget {
  const CreateProductVariantScreen({super.key});

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
      cubit.setProductError('Product is required');
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
      cubit.setStockQuantityError('Stock quantity is required');
      isValid = false;
    } else {
      final stock = int.tryParse(stockText);
      if (stock == null) {
        cubit.setStockQuantityError('Please enter a valid number');
        isValid = false;
      } else if (stock < 0) {
        cubit.setStockQuantityError('Stock quantity must be 0 or greater');
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
        title: const Text('Select Product'),
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
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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
        child: Column(
          children: [
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
                  const Expanded(
                    child: Text(
                      'Create Product Variant',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
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
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Product',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    fw.GestureDetector(
                                      onTap: () {
                                        _showProductSelector(context, cubit);
                                      },
                                      child: Text(
                                        'Select',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _productIdController,
                                  placeholder: const Text('Select product'),
                                  enabled: false,
                                ),
                                if (cubit.productError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.productError!,
                                      style: const TextStyle(
                                        color: Color(0xFFEF4444),
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
                                    const Text(
                                      'Color',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(Optional)',
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
                                  placeholder: const Text(
                                    'Enter color (optional)',
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
                                      style: const TextStyle(
                                        color: Color(0xFFEF4444),
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
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Size',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(Optional)',
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
                                  placeholder: const Text(
                                    'Enter size (optional)',
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
                                      style: const TextStyle(
                                        color: Color(0xFFEF4444),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Stock Quantity Field
                        BlocBuilder<ProductVariantCubit, ProductVariantState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Stock Quantity',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _stockQuantityController,
                                  placeholder: const Text(
                                    'Enter stock quantity',
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
                                      style: const TextStyle(
                                        color: Color(0xFFEF4444),
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
                                const Expanded(
                                  child: Text(
                                    'Active',
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
                                title: const Text('Success'),
                                content: const Text(
                                  'Product variant created successfully.',
                                ),
                                actions: [
                                  PrimaryButton(
                                    child: const Text('OK'),
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
                                title: const Text('Error'),
                                content: Text(error),
                                actions: [
                                  PrimaryButton(
                                    child: const Text('OK'),
                                    onPressed: () => fw.Navigator.of(ctx).pop(),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: PrimaryButton(
                            child: const Text('Create Product Variant'),
                          ),
                        ),
                      ],
                    ),
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
