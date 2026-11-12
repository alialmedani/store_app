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
              'this_will_generate_variants'.tr(args: ['$totalVariants']),
              style: const TextStyle(
                fontSize: AppDesignTokens.bodyFontSize + 1,
                fontWeight: AppDesignTokens.semiBold,
              ),
            ),
            const SizedBox(height: AppDesignTokens.itemGap),
            Text(
              _countLabel(),
              style: TextStyle(
                fontSize: AppDesignTokens.bodyFontSize,
                color: Theme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: AppDesignTokens.smallGap),
            Text(
              'each_variant_stock'.tr(args: [_defaultStockController.text.trim()]),
              style: TextStyle(
                fontSize: AppDesignTokens.bodyFontSize,
                color: Theme.of(context).colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(height: AppDesignTokens.itemGap),
            fw.Container(
              padding: const fw.EdgeInsets.all(AppDesignTokens.itemGap),
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
                      fontSize: AppDesignTokens.bodyFontSize - 1,
                      fontWeight: AppDesignTokens.semiBold,
                      color: Theme.of(context).colorScheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: AppDesignTokens.smallGap - 2),
                  ...colors.take(2).map((color) {
                    return Padding(
                      padding: const EdgeInsets.only(top: AppDesignTokens.tinyGap),
                      child: Text(
                        _needsSize
                            ? '• $color - ${sizes.first}${sizes.length > 1 ? ", $color - ${sizes[1]}" : ""}'
                            : '• $color',
                        style: TextStyle(
                          fontSize: AppDesignTokens.captionFontSize,
                          color: Theme.of(context).colorScheme.mutedForeground,
                        ),
                      ),
                    );
                  }),
                  if (colors.length > 2 || sizes.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: AppDesignTokens.tinyGap),
                      child: Text(
                        'and_more'.tr(args: ['${totalVariants - 2}']),
                        style: TextStyle(
                          fontSize: AppDesignTokens.captionFontSize,
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
            AppHeader(
              title: 'generate_variants'.tr(),
              onBack: () => fw.Navigator.of(context).pop(),
            ),
          ]), body: SingleChildScrollView(
                padding: const EdgeInsets.all(
                  AppDesignTokens.screenPaddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info Card
                    AppCard(
                      elevated: true,
                      child: Row(
                        children: [
                          AppIconChip(
                            icon: Icons.auto_awesome,
                            color: AppDesignTokens.accentSecondaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: AppDesignTokens.itemGap),
                          Expanded(
                            child: Text(
                              'auto_generate_all_combinations_with_sa'.tr(),
                              style: TextStyle(
                                fontSize: AppDesignTokens.bodyFontSize - 1,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDesignTokens.cardGap),

                    // Product Selection Card
                    AppCard(
                      elevated: true,
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
                    const SizedBox(height: AppDesignTokens.cardGap),

                    // Colors Card
                    AppCard(
                      elevated: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'colors'.tr(),
                            style: const TextStyle(
                              fontSize: AppDesignTokens.cardTitleFontSize - 1,
                              fontWeight: AppDesignTokens.bold,
                            ),
                          ),
                          const SizedBox(height: AppDesignTokens.itemGap),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _colorController,
                                  placeholder: Text('enter_color'.tr()),
                                  onSubmitted: (_) => _addColor(),
                                ),
                              ),
                              const SizedBox(width: AppDesignTokens.smallGap),
                              IconButton(
                                icon: const Icon(Icons.add, size: 20),
                                variance: ButtonVariance.primary,
                                onPressed: _addColor,
                              ),
                            ],
                          ),
                          if (colors.isNotEmpty) ...[
                            const SizedBox(height: AppDesignTokens.itemGap),
                            Wrap(
                              spacing: AppDesignTokens.smallGap,
                              runSpacing: AppDesignTokens.smallGap,
                              children: colors.map((color) {
                                return fw.GestureDetector(
                                  onTap: () => _removeColor(color),
                                  child: fw.Container(
                                    padding: const fw.EdgeInsets.symmetric(
                                      horizontal: AppDesignTokens.itemGap + 2,
                                      vertical: AppDesignTokens.smallGap,
                                    ),
                                    decoration: fw.BoxDecoration(
                                      color: AppDesignTokens.primarySoftColor,
                                      borderRadius: fw.BorderRadius.circular(
                                        AppDesignTokens.badgeRadius,
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
                                            fontSize: AppDesignTokens.bodyFontSize - 1,
                                            fontWeight: AppDesignTokens.semiBold,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(width: AppDesignTokens.tinyGap + 2),
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
                    const SizedBox(height: AppDesignTokens.cardGap),

                    if (_needsSize) ...[
                    AppCard(
                      elevated: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'sizes'.tr(),
                            style: const TextStyle(
                              fontSize: AppDesignTokens.cardTitleFontSize - 1,
                              fontWeight: AppDesignTokens.bold,
                            ),
                          ),
                          const SizedBox(height: AppDesignTokens.itemGap),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _sizeController,
                                  placeholder: Text('enter_size'.tr()),
                                  onSubmitted: (_) => _addSize(),
                                ),
                              ),
                              const SizedBox(width: AppDesignTokens.smallGap),
                              IconButton(
                                icon: const Icon(Icons.add, size: 20),
                                variance: ButtonVariance.primary,
                                onPressed: _addSize,
                              ),
                            ],
                          ),
                          if (sizes.isNotEmpty) ...[
                            const SizedBox(height: AppDesignTokens.itemGap),
                            Wrap(
                              spacing: AppDesignTokens.smallGap,
                              runSpacing: AppDesignTokens.smallGap,
                              children: sizes.map((size) {
                                return fw.GestureDetector(
                                  onTap: () => _removeSize(size),
                                  child: fw.Container(
                                    padding: const fw.EdgeInsets.symmetric(
                                      horizontal: AppDesignTokens.itemGap + 2,
                                      vertical: AppDesignTokens.smallGap,
                                    ),
                                    decoration: fw.BoxDecoration(
                                      color: AppDesignTokens.successSoftColor,
                                      borderRadius: fw.BorderRadius.circular(
                                        AppDesignTokens.badgeRadius,
                                      ),
                                      border: fw.Border.all(
                                        color: AppDesignTokens.successColor
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          size,
                                          style: TextStyle(
                                            fontSize: AppDesignTokens.bodyFontSize - 1,
                                            fontWeight: AppDesignTokens.semiBold,
                                            color: AppDesignTokens.successColor,
                                          ),
                                        ),
                                        const SizedBox(width: AppDesignTokens.tinyGap + 2),
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
                    const SizedBox(height: AppDesignTokens.cardGap),
                    ],

                    // Settings Card
                    AppCard(
                      elevated: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'default_stock_quantity'.tr(),
                            style: const TextStyle(
                              fontSize: AppDesignTokens.bodyFontSize,
                              fontWeight: AppDesignTokens.semiBold,
                            ),
                          ),
                          const SizedBox(height: AppDesignTokens.smallGap),
                          TextField(
                            controller: _defaultStockController,
                            placeholder: Text(
                              'enter_default_stock_quantity'.tr(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: AppDesignTokens.itemGap),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'skip_existing_variants'.tr(),
                                  style: const TextStyle(
                                    fontSize: AppDesignTokens.bodyFontSize,
                                    fontWeight: AppDesignTokens.semiBold,
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
                          const SizedBox(height: AppDesignTokens.itemGap),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'set_as_active'.tr(),
                                  style: const TextStyle(
                                    fontSize: AppDesignTokens.bodyFontSize,
                                    fontWeight: AppDesignTokens.semiBold,
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
                    const SizedBox(height: AppDesignTokens.cardGap),

                    // Preview Card
                    if (totalVariants > 0)
                      AppCard(
                        elevated: true,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'total_variants'.tr(),
                                    style: const TextStyle(
                                      fontSize: AppDesignTokens.bodyFontSize - 1,
                                      fontWeight: AppDesignTokens.semiBold,
                                    ),
                                  ),
                                  const SizedBox(height: AppDesignTokens.tinyGap),
                                  Text(
                                    'variants_2'.tr(args: ['$totalVariants']),
                                    style: TextStyle(
                                      fontSize: AppDesignTokens.sectionTitleFontSize + 2,
                                      fontWeight: AppDesignTokens.bold,
                                      color: AppDesignTokens.accentSecondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: AppDesignTokens.tinyGap),
                                  Text(
                                    _countLabel(),
                                    style: TextStyle(
                                      fontSize: AppDesignTokens.captionFontSize,
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
                    const SizedBox(height: AppDesignTokens.sectionGap),

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
                            const SizedBox(width: AppDesignTokens.smallGap),
                            Text(
                              'generate_all_variants'.tr(),
                              style: const TextStyle(
                                fontSize: AppDesignTokens.bodyFontSize + 1,
                                fontWeight: AppDesignTokens.semiBold,
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
