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
import '../data/usecase/bulk_create_product_variant_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:store/core/constant/enum/enum.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';

/// Bulk Create Variant Screen
/// Create multiple specific variants with different stock quantities
class BulkCreateVariantScreen extends StatefulWidget {
  final ProductModel? initialProduct;
  const BulkCreateVariantScreen({super.key, this.initialProduct});

  @override
  State<BulkCreateVariantScreen> createState() =>
      _BulkCreateVariantScreenState();
}

class _BulkCreateVariantScreenState extends State<BulkCreateVariantScreen> {
  ProductModel? selectedProduct;
  final List<_ColorBlock> blocks = [_ColorBlock()];

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
  CreateModelCubit? createModelCubit;

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.initialProduct;
    if (selectedProduct != null) _loadSizeType(selectedProduct!);
  }

  int _badBlock = 0;

  /// Collects variants from the color blocks. Null if a block is incomplete.
  /// A size added N times has quantity N.
  List<VariantItem>? _collect() {
    final items = <VariantItem>[];
    for (var i = 0; i < blocks.length; i++) {
      final b = blocks[i];
      final color = b.color.text.trim();
      if (_sizeKnown && !_needsSize) {
        // No sizes for this category (e.g. accessories): color is optional,
        // quantity is required.
        if (color.isEmpty && b.qty == 0) continue;
        if (b.qty <= 0) {
          _badBlock = i + 1;
          return null;
        }
        items.add(
          VariantItem(
            color: color,
            size: '',
            stockQuantity: b.qty,
            isActive: true,
          ),
        );
        continue;
      }
      if (color.isEmpty && b.sizes.isEmpty) continue; // empty block: ignore
      if (color.isEmpty || b.sizes.isEmpty) {
        _badBlock = i + 1;
        return null;
      }
      b.sizes.forEach((size, qty) {
        items.add(
          VariantItem(
            color: color,
            size: size,
            stockQuantity: qty,
            isActive: true,
          ),
        );
      });
    }
    return items;
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
                        _loadSizeType(product);
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
    final parsed = _collect();
    if (parsed == null) {
      _showErrorDialog('color_block_incomplete'.tr(args: ['$_badBlock']));
      return false;
    }
    if (parsed.isEmpty) {
      _showErrorDialog('enter_at_least_one_color'.tr());
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

  @override
  void dispose() {
    for (final b in blocks) {
      b.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      'bulk_create_variants'.tr(),
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

                    // Color blocks
                    for (var i = 0; i < blocks.length; i++) ...[
                      _ColorBlockCard(
                        index: i,
                        block: blocks[i],
                        canRemove: blocks.length > 1,
                        mode: !_sizeKnown ? 0 : (_needsSize ? 1 : 2),
                        onChanged: () => setState(() {}),
                        onRemove: () => setState(() {
                          blocks[i].dispose();
                          blocks.removeAt(i);
                        }),
                      ),
                      const SizedBox(height: 12),
                    ],
                    OutlineButton(
                      onPressed: () => setState(() => blocks.add(_ColorBlock())),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 18),
                          const SizedBox(width: 8),
                          Text('add_another_color'.tr()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Builder(
                      builder: (context) {
                        final total = blocks.fold<int>(
                          0,
                          (sum, b) => sum +
                              (_needsSize
                                  ? (b.color.text.trim().isEmpty
                                        ? 0
                                        : b.sizes.length)
                                  : (b.qty > 0 ? 1 : 0)),
                        );
                        return Center(
                          child: Text(
                            'variants_total'.tr(args: ['$total']),
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.mutedForeground,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    CreateModel<List<ProductVariantModel>>(
                      withValidation: true,
                      onTap: () {
                        return _validateForm();
                      },
                      useCaseCallBack: (data) {
                        final params = BulkCreateProductVariantParams(
                          productId: selectedProduct!.id!,
                          variants: _collect() ?? [],
                        );

                        return context
                            .read<ProductVariantCubit>()
                            .bulkCreateProductVariant(params);
                      },
                      onSuccess: (variants) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('success'.tr()),
                            content: Text(
                              'variants_created_successfully'.tr(args: ['${variants.length}']),
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
                            Icon(Icons.check, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'create_all_variants'.tr(),
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

class _ColorBlock {
  final color = TextEditingController();
  final sizeInput = TextEditingController();
  final Map<String, int> sizes = {};
  int qty = 0;

  void addSizes(String text) {
    for (final t in text.split(RegExp(r'[\s,،]+'))) {
      if (t.isEmpty) continue;
      sizes[t] = (sizes[t] ?? 0) + 1;
    }
  }

  void dispose() {
    color.dispose();
    sizeInput.dispose();
  }
}

/// One color with its sizes. Adding the same size again increases its quantity.
class _ColorBlockCard extends StatelessWidget {
  final int index;
  final _ColorBlock block;
  final bool canRemove;
  /// 0 = product not chosen yet, 1 = sizes, 2 = quantity only
  final int mode;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  const _ColorBlockCard({
    required this.index,
    required this.block,
    required this.canRemove,
    required this.mode,
    required this.onChanged,
    required this.onRemove,
  });

  void _add() {
    block.addSizes(block.sizeInput.text);
    block.sizeInput.clear();
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'color_block_title'.tr(args: ['${index + 1}']),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                if (canRemove)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onRemove,
                    variance: ButtonVariance.ghost,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: block.color,
              onChanged: (_) => onChanged(),
              placeholder: Text('color_name'.tr()),
            ),
            if (mode == 0) ...[
              const SizedBox(height: 10),
              Text(
                'select_product_first'.tr(),
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ] else if (mode == 2) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'quantity'.tr(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: () {
                    if (block.qty > 0) block.qty--;
                    onChanged();
                  },
                  variance: ButtonVariance.ghost,
                ),
                SizedBox(
                  width: 36,
                  child: Center(
                    child: Text(
                      '${block.qty}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () {
                    block.qty++;
                    onChanged();
                  },
                  variance: ButtonVariance.ghost,
                ),
              ],
            ),
            ] else ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: block.sizeInput,
                    onSubmitted: (_) => _add(),
                    placeholder: Text('add_sizes_hint'.tr()),
                  ),
                ),
                const SizedBox(width: 8),
                PrimaryButton(
                  onPressed: _add,
                  child: const Icon(Icons.add, size: 18),
                ),
              ],
            ),
            if (block.sizes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final e in block.sizes.entries)
                    _SizeChip(
                      size: e.key,
                      qty: e.value,
                      onMinus: () {
                        if (e.value <= 1) {
                          block.sizes.remove(e.key);
                        } else {
                          block.sizes[e.key] = e.value - 1;
                        }
                        onChanged();
                      },
                      onPlus: () {
                        block.sizes[e.key] = e.value + 1;
                        onChanged();
                      },
                    ),
                ],
              ),
            ],
            ],
          ],
        ),
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  final String size;
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _SizeChip({
    required this.size,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return fw.Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: fw.BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: fw.BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          fw.GestureDetector(
            onTap: onMinus,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                qty <= 1 ? Icons.close : Icons.remove,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Text(
            '$size  ×$qty',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          fw.GestureDetector(
            onTap: onPlus,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.add, size: 16, color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
