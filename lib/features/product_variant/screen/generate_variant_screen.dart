import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../product/cubit/product_cubit.dart';
import '../../product/data/model/product_model.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/usecase/generate_product_variant_usecase.dart';

/// Generate Variant Screen
/// Automatically generate all color-size combinations (Cartesian Product)
class GenerateVariantScreen extends StatefulWidget {
  const GenerateVariantScreen({super.key});

  @override
  State<GenerateVariantScreen> createState() => _GenerateVariantScreenState();
}

class _GenerateVariantScreenState extends State<GenerateVariantScreen> {
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  final _defaultStockController = TextEditingController(text: '10');

  ProductModel? selectedProduct;
  List<String> colors = [];
  List<String> sizes = [];
  bool skipExisting = false;
  bool isActive = true;
  CreateModelCubit? createModelCubit;

  void _addColor() {
    final color = _colorController.text.trim();
    if (color.isNotEmpty && !colors.contains(color)) {
      setState(() {
        colors.add(color);
        _colorController.clear();
      });
    }
  }

  void _removeColor(String color) {
    setState(() {
      colors.remove(color);
    });
  }

  void _addSize() {
    final size = _sizeController.text.trim();
    if (size.isNotEmpty && !sizes.contains(size)) {
      setState(() {
        sizes.add(size);
        _sizeController.clear();
      });
    }
  }

  void _removeSize(String size) {
    setState(() {
      sizes.remove(size);
    });
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
                          color: Theme.of(context)
                              .colorScheme
                              .border
                              .withOpacity(0.3),
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

    if (colors.isEmpty) {
      _showErrorDialog('Please add at least one color');
      return false;
    }

    if (sizes.isEmpty) {
      _showErrorDialog('Please add at least one size');
      return false;
    }

    final stock = int.tryParse(_defaultStockController.text.trim());
    if (stock == null || stock < 0) {
      _showErrorDialog('Please enter a valid default stock quantity');
      return false;
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

  void _showGeneratePreview() {
    final totalVariants = colors.length * sizes.length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Generate Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will generate $totalVariants variants:',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${colors.length} colors × ${sizes.length} sizes',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Each variant: ${_defaultStockController.text.trim()} stock',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 12),
            fw.Container(
              padding: const fw.EdgeInsets.all(12),
              decoration: fw.BoxDecoration(
                color: Theme.of(context).colorScheme.muted.withOpacity(0.5),
                borderRadius: fw.BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Example combinations:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...colors.take(2).map((color) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '• $color - ${sizes.first}${sizes.length > 1 ? ", $color - ${sizes[1]}" : ""}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.mutedForeground,
                        ),
                      ),
                    );
                  }),
                  if (colors.length > 2 || sizes.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '• And ${totalVariants - 2} more...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.mutedForeground,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          OutlineButton(
            onPressed: () => fw.Navigator.of(ctx).pop(),
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
    _defaultStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalVariants = colors.length * sizes.length;

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
                      'Generate Variants',
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
                    // Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            fw.Container(
                              padding: const fw.EdgeInsets.all(10),
                              decoration: fw.BoxDecoration(
                                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                borderRadius: fw.BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFF8B5CF6),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Auto-generate all combinations with same stock quantity',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

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
                                color: theme.colorScheme.muted.withOpacity(0.5),
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

                    // Colors Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Colors',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _colorController,
                                    placeholder: const Text('Enter color'),
                                    onSubmitted: (_) => _addColor(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 20),
                                  variance: ButtonVariance.primary,
                                  onPressed: _addColor,
                                ),
                              ],
                            ),
                            if (colors.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: colors.map((color) {
                                  return fw.GestureDetector(
                                    onTap: () => _removeColor(color),
                                    child: fw.Container(
                                      padding: const fw.EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: fw.BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.1),
                                        borderRadius:
                                            fw.BorderRadius.circular(8),
                                        border: fw.Border.all(
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            color,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.close,
                                            size: 14,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sizes Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sizes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _sizeController,
                                    placeholder: const Text('Enter size'),
                                    onSubmitted: (_) => _addSize(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 20),
                                  variance: ButtonVariance.primary,
                                  onPressed: _addSize,
                                ),
                              ],
                            ),
                            if (sizes.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: sizes.map((size) {
                                  return fw.GestureDetector(
                                    onTap: () => _removeSize(size),
                                    child: fw.Container(
                                      padding: const fw.EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: fw.BoxDecoration(
                                        color: const Color(0xFF10B981)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            fw.BorderRadius.circular(8),
                                        border: fw.Border.all(
                                          color: const Color(0xFF10B981)
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            size,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF10B981),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(
                                            Icons.close,
                                            size: 14,
                                            color: Color(0xFF10B981),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Settings Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Default Stock Quantity',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _defaultStockController,
                              placeholder: const Text(
                                'Enter default stock quantity',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Skip Existing Variants',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: skipExisting,
                                  onChanged: (value) {
                                    setState(() {
                                      skipExisting = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Set as Active',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: isActive,
                                  onChanged: (value) {
                                    setState(() {
                                      isActive = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Preview Card
                    if (totalVariants > 0)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Variants',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$totalVariants variants',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF8B5CF6),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${colors.length} colors × ${sizes.length} sizes',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.visibility, size: 20),
                                variance: ButtonVariance.ghost,
                                onPressed: _showGeneratePreview,
                              ),
                            ],
                          ),
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
                        final params = GenerateProductVariantParams(
                          productId: selectedProduct!.id!,
                          colors: colors,
                          sizes: sizes,
                          defaultStockQuantity:
                              int.parse(_defaultStockController.text.trim()),
                          skipExisting: skipExisting,
                          isActive: isActive,
                        );

                        return context
                            .read<ProductVariantCubit>()
                            .generateProductVariant(params);
                      },
                      onSuccess: (variants) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Success'),
                            content: Text(
                              '${variants.length} variants generated successfully.',
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
                            Icon(
                              Icons.auto_awesome,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Generate All Variants',
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
