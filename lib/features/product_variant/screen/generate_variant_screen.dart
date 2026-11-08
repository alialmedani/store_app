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
import '../data/usecase/generate_product_variant_usecase.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:store/core/constant/enum/enum.dart';

/// Generate Variant Screen
/// Automatically generate all color-size combinations (Cartesian Product)
class GenerateVariantScreen extends StatefulWidget {
  final ProductModel? initialProduct;
  const GenerateVariantScreen({super.key, this.initialProduct});

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

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.initialProduct;
    if (selectedProduct != null) _loadSizeType(selectedProduct!);
  }

  SizeType? _sizeType;
  bool _sizeLoading = false;

  /// Size-related inputs stay hidden until a product is chosen and its
  /// category type is known.
  bool get _sizeKnown => selectedProduct != null && !_sizeLoading;

  bool get _needsSize =>
      _sizeKnown &&
      _sizeType != SizeType.none &&
      _sizeType != SizeType.oneSize;

  void _loadSizeType(ProductModel p) {
    _sizeType = p.category?.sizeType;
    _sizeLoading = _sizeType == null;
    if (_sizeLoading) {
      ProductVariantCubit.resolveSizeType(p).then((t) {
        if (mounted && selectedProduct?.id == p.id) {
          setState(() {
            _sizeType = t;
            _sizeLoading = false;
          });
        }
      });
    }
  }

  int get _sizeCount => _needsSize ? sizes.length : 1;

  String _countLabel() => _needsSize
      ? 'colors_sizes'.tr(args: ['${colors.length}', '${sizes.length}'])
      : 'colors_only'.tr(args: ['${colors.length}']);

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
        title: Text('select_product'.tr()),
        content: fw.SizedBox(
          width: double.maxFinite,
          height: 400,
          child: PaginationList<ProductModel>(
            withPagination: true,
            withRefresh: true,
            loadingWidget: SelectorListSkeleton(withSubtitle: false),
            repositoryCallBack: (data) {
              return context.read<ProductCubit>().fetchProductList(data);
            },
            listBuilder: (list) {
              return fw.ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final product = list[index];
                  return SelectorTile(
                    title: product.name ?? 'N/A',
                    onTap: () {
                      setState(() {
                        selectedProduct = product;
                        _loadSizeType(product);
                      });
                      fw.Navigator.of(dialogContext).pop();
                    },
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

  bool _validateForm() {
    if (selectedProduct == null) {
      _showErrorDialog('please_select_a_product'.tr());
      return false;
    }

    if (colors.isEmpty) {
      _showErrorDialog('please_add_at_least_one_color'.tr());
      return false;
    }

    if (_needsSize && sizes.isEmpty) {
      _showErrorDialog('please_add_at_least_one_size'.tr());
      return false;
    }

    final stock = int.tryParse(_defaultStockController.text.trim());
    if (stock == null || stock < 0) {
      _showErrorDialog('please_enter_a_valid_default_stock_qua'.tr());
      return false;
    }

    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('validation_error'.tr()),
        content: Text(message),
        actions: [
          PrimaryButton(
            child: Text('ok'.tr()),
            onPressed: () => fw.Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _showGeneratePreview() {
    final totalVariants = colors.length * _sizeCount;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('generate_preview'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'this_will_generate_variants'.tr(args: ['${totalVariants}']),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              _countLabel(),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'each_variant_stock'.tr(args: ['${_defaultStockController.text.trim()}']),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 12),
            fw.Container(
              padding: const fw.EdgeInsets.all(12),
              decoration: fw.BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.muted.withValues(alpha: 0.5),
                borderRadius: fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'example_combinations'.tr(),
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
                        _needsSize
                            ? '• $color - ${sizes.first}${sizes.length > 1 ? ", $color - ${sizes[1]}" : ""}'
                            : '• $color',
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
                        'and_more'.tr(args: ['${totalVariants - 2}']),
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
            child: Text('cancel'.tr()),
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
    final totalVariants = colors.length * _sizeCount;

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
                      'generate_variants'.tr(),
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
                                color: const Color(
                                  0xFF8E7CFF,
                                ).withValues(alpha: 0.1),
                                borderRadius: fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
                              ),
                              child: Icon(
                                Icons.auto_awesome,
                                color: AppDesignTokens.accentSecondaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'auto_generate_all_combinations_with_sa'.tr(),
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
                            AppSelectorField(
                              label: 'product'.tr(),
                              value: selectedProduct?.name,
                              placeholder: 'no_product_selected'.tr(),
                              onTap: () => _showProductSelector(context),
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
                            Text(
                              'colors'.tr(),
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
                                    placeholder: Text('enter_color'.tr()),
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
                                            .withValues(alpha: 0.1),
                                        borderRadius: fw.BorderRadius.circular(
                                          8,
                                        ),
                                        border: fw.Border.all(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.3),
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

                    if (_needsSize) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'sizes'.tr(),
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
                                    placeholder: Text('enter_size'.tr()),
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
                                        color: const Color(
                                          0xFF4ADE9A,
                                        ).withValues(alpha: 0.1),
                                        borderRadius: fw.BorderRadius.circular(
                                          8,
                                        ),
                                        border: fw.Border.all(
                                          color: const Color(
                                            0xFF4ADE9A,
                                          ).withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            size,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppDesignTokens.successColor,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.close,
                                            size: 14,
                                            color: AppDesignTokens.successColor,
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
                    ],

                    // Settings Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'default_stock_quantity'.tr(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _defaultStockController,
                              placeholder: Text(
                                'enter_default_stock_quantity'.tr(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'skip_existing_variants'.tr(),
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
                                Expanded(
                                  child: Text(
                                    'set_as_active'.tr(),
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
                                    Text(
                                      'total_variants'.tr(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'variants_2'.tr(args: ['${totalVariants}']),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppDesignTokens.accentSecondaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _countLabel(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.colorScheme.mutedForeground,
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
                    CreateModel<List<ProductVariantModel>>(
                      withValidation: true,
                      onTap: () {
                        return _validateForm();
                      },
                      useCaseCallBack: (data) {
                        final params = GenerateProductVariantParams(
                          productId: selectedProduct!.id!,
                          colors: colors,
                          sizes: _needsSize ? sizes : [''],
                          defaultStockQuantity: int.parse(
                            _defaultStockController.text.trim(),
                          ),
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
                            title: Text('success'.tr()),
                            content: Text(
                              'variants_generated_successfully'.tr(args: ['${variants.length}']),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'generate_all_variants'.tr(),
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
              )),
      ),
    );
  }
}
