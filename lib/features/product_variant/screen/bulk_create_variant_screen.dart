import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../product/cubit/product_cubit.dart';
import '../../product/data/model/product_model.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/usecase/bulk_create_product_variant_usecase.dart';

/// Bulk Create Variant Screen
/// Create multiple specific variants with different stock quantities
class BulkCreateVariantScreen extends StatefulWidget {
  const BulkCreateVariantScreen({super.key});

  @override
  State<BulkCreateVariantScreen> createState() =>
      _BulkCreateVariantScreenState();
}

class _BulkCreateVariantScreenState extends State<BulkCreateVariantScreen> {
  ProductModel? selectedProduct;
  List<_VariantFormData> variants = [];
  CreateModelCubit? createModelCubit;

  @override
  void initState() {
    super.initState();
    // Add initial empty variant
    _addVariant();
  }

  void _addVariant() {
    setState(() {
      variants.add(_VariantFormData());
    });
  }

  void _removeVariant(int index) {
    if (variants.length > 1) {
      setState(() {
        variants.removeAt(index);
      });
    }
  }

  void _showProductSelector(BuildContext context) {
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
                      setState(() {
                        selectedProduct = product;
                      });
                      fw.Navigator.of(dialogContext).pop();
                    },
                    child: fw.Container(
                      margin: const fw.EdgeInsets.only(bottom: 8),
                      padding: const fw.EdgeInsets.all(12),
                      decoration: fw.BoxDecoration(
                        color: Theme.of(context).colorScheme.muted,
                        borderRadius: fw.BorderRadius.circular(8),
                        border: fw.Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.border.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        product.name ?? 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.w600),
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

  bool _validateForm() {
    if (selectedProduct == null) {
      _showErrorDialog('Please select a product');
      return false;
    }

    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];
      final variantNum = i + 1;

      if (variant.colorController.text.trim().isEmpty) {
        _showErrorDialog('Variant $variantNum: Color is required');
        return false;
      }

      if (variant.sizeController.text.trim().isEmpty) {
        _showErrorDialog('Variant $variantNum: Size is required');
        return false;
      }

      final stock = int.tryParse(variant.stockController.text.trim());
      if (stock == null || stock < 0) {
        _showErrorDialog(
          'Variant $variantNum: Please enter a valid stock quantity',
        );
        return false;
      }
    }

    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Validation Error'),
        content: Text(message),
        actions: [
          PrimaryButton(
            child: const Text('OK'),
            onPressed: () => fw.Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var variant in variants) {
      variant.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      'Bulk Create Variants',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Selection Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Product',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                fw.GestureDetector(
                                  onTap: () => _showProductSelector(context),
                                  child: Text(
                                    selectedProduct == null
                                        ? 'Select'
                                        : 'Change',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            fw.Container(
                              padding: const fw.EdgeInsets.all(16),
                              decoration: fw.BoxDecoration(
                                color: theme.colorScheme.muted.withValues(
                                  alpha: 0.5,
                                ),
                                borderRadius: fw.BorderRadius.circular(8),
                                border: fw.Border.all(
                                  color: theme.colorScheme.border,
                                ),
                              ),
                              child: Text(
                                selectedProduct?.name ?? 'No product selected',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedProduct == null
                                      ? theme.colorScheme.mutedForeground
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Variants List
                    ...variants.asMap().entries.map((entry) {
                      final index = entry.key;
                      final variant = entry.value;
                      return _VariantCard(
                        index: index,
                        variant: variant,
                        canRemove: variants.length > 1,
                        onRemove: () => _removeVariant(index),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Add Variant Button
                    OutlineButton(
                      onPressed: _addVariant,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Add Another Variant',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    CreateModel<List<ProductModel>>(
                      withValidation: true,
                      onTap: () {
                        return _validateForm();
                      },
                      useCaseCallBack: (data) {
                        final params = BulkCreateProductVariantParams(
                          productId: selectedProduct!.id!,
                          variants: variants.map((v) {
                            return VariantItem(
                              color: v.colorController.text.trim(),
                              size: v.sizeController.text.trim(),
                              stockQuantity: int.parse(
                                v.stockController.text.trim(),
                              ),
                              isActive: v.isActive,
                            );
                          }).toList(),
                        );

                        return context
                            .read<ProductVariantCubit>()
                            .bulkCreateProductVariant(params);
                      },
                      onSuccess: (variants) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Success'),
                            content: Text(
                              '${variants.length} variants created successfully.',
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Create All Variants',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Variant Form Data Class
class _VariantFormData {
  final colorController = TextEditingController();
  final sizeController = TextEditingController();
  final stockController = TextEditingController(text: '0');
  bool isActive = true;

  void dispose() {
    colorController.dispose();
    sizeController.dispose();
    stockController.dispose();
  }
}

/// Variant Card Widget
class _VariantCard extends StatefulWidget {
  final int index;
  final _VariantFormData variant;
  final bool canRemove;
  final VoidCallback onRemove;

  const _VariantCard({
    required this.index,
    required this.variant,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  State<_VariantCard> createState() => _VariantCardState();
}

class _VariantCardState extends State<_VariantCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Variant ${widget.index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (widget.canRemove)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    variance: ButtonVariance.ghost,
                    onPressed: widget.onRemove,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Color Field
            const Text(
              'Color',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: widget.variant.colorController,
              placeholder: const Text('Enter color'),
            ),
            const SizedBox(height: 16),

            // Size Field
            const Text(
              'Size',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: widget.variant.sizeController,
              placeholder: const Text('Enter size'),
            ),
            const SizedBox(height: 16),

            // Stock Quantity Field
            const Text(
              'Stock Quantity',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: widget.variant.stockController,
              placeholder: const Text('Enter stock quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Is Active Toggle
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Active',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Switch(
                  value: widget.variant.isActive,
                  onChanged: (value) {
                    setState(() {
                      widget.variant.isActive = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
