import 'dart:async';

import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/utils/image_helper.dart';
import '../../cubit/add_product_dialog_cubit.dart';
import '../../../category/cubit/category_cubit.dart';
import '../../../category/data/model/category_model.dart';
import '../../../product/cubit/product_cubit.dart';
import '../../../product/data/model/product_model.dart';
import '../../../product_variant/data/model/product_variant_model.dart';

/// "Catalog + tray" product picker.
///
/// A scroll-controlled bottom sheet with one continuous product catalog
/// (category filter chips + optional backend search) where each product row
/// expands in place to pick a colour/size and stage a line into a tray. The
/// primary CTA commits every staged line to the order (one awaited call per
/// line) via [onItemAdded], then the sheet closes.
///
/// All filter / expansion / selection / tray state lives in
/// [AddProductDialogCubit] (CLAUDE.md rule 4). Only text-controller/debounce
/// is local widget state.
class AddProductDialog {
  const AddProductDialog._();

  /// Opens the picker as a near-full-height modal bottom sheet.
  ///
  /// [onItemAdded] is awaited once per staged line, sequentially.
  static Future<void> show(
    fw.BuildContext context, {
    required Future<void> Function(String productVariantId, int quantity)
        onItemAdded,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const fw.Color(0x00000000),
      builder: (_) => BlocProvider(
        create: (_) => AddProductDialogCubit(),
        child: _AddProductSheet(onItemAdded: onItemAdded),
      ),
    );
  }
}

class _AddProductSheet extends fw.StatelessWidget {
  final Future<void> Function(String productVariantId, int quantity)
      onItemAdded;

  const _AddProductSheet({required this.onItemAdded});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<AddProductDialogCubit>();
    final bottomInset = fw.MediaQuery.viewInsetsOf(context).bottom;

    return fw.FractionallySizedBox(
      heightFactor: 0.92,
      child: fw.Container(
        decoration: fw.BoxDecoration(
          color: AppDesignTokens.backgroundColor,
          borderRadius: const fw.BorderRadius.vertical(
            top: fw.Radius.circular(AppDesignTokens.cardRadius + 8),
          ),
        ),
        clipBehavior: fw.Clip.antiAlias,
        child: fw.Padding(
          padding: fw.EdgeInsets.only(bottom: bottomInset),
          child: BlocBuilder<AddProductDialogCubit, AddProductDialogState>(
            builder: (context, _) {
              return fw.Column(
                crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                children: [
                  _Handle(),
                  _Header(theme: theme),
                  _SearchField(onChanged: cubit.setSearch),
                  const fw.SizedBox(height: AppDesignTokens.smallGap),
                  _CategoryFilters(
                    selectedCategoryId: cubit.selectedCategoryId,
                    onSelected: cubit.selectCategory,
                  ),
                  const fw.SizedBox(height: AppDesignTokens.smallGap),
                  fw.Expanded(
                    child: BlocProvider(
                      key: fw.ValueKey(
                        '${cubit.selectedCategoryId ?? 'all'}'
                        '|${cubit.searchQuery}',
                      ),
                      create: (_) => ProductCubit(),
                      child: _CatalogList(
                        categoryId: cubit.selectedCategoryId,
                        filter: cubit.searchQuery,
                      ),
                    ),
                  ),
                  _TrayAndCommit(
                    theme: theme,
                    onItemAdded: onItemAdded,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Handle extends fw.StatelessWidget {
  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Padding(
      padding: const fw.EdgeInsets.only(top: 10, bottom: 4),
      child: fw.Center(
        child: fw.Container(
          width: 40,
          height: 4,
          decoration: fw.BoxDecoration(
            color: AppDesignTokens.mutedBorderColor,
            borderRadius: fw.BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _Header extends fw.StatelessWidget {
  final ThemeData theme;
  const _Header({required this.theme});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Padding(
      padding: const fw.EdgeInsetsDirectional.fromSTEB(
        AppDesignTokens.screenPaddingHorizontal,
        AppDesignTokens.smallGap,
        AppDesignTokens.smallGap,
        AppDesignTokens.smallGap,
      ),
      child: fw.Row(
        children: [
          fw.Expanded(
            child: Text(
              'add_product_to_order'.tr(),
              style: const fw.TextStyle(
                fontSize: AppDesignTokens.sectionTitleFontSize,
                fontWeight: AppDesignTokens.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () => fw.Navigator.pop(context),
            variance: ButtonVariance.ghost,
          ),
        ],
      ),
    );
  }
}

/// Backend-supported free-text product search (`Filter`). Owns its controller
/// and a debounce timer locally; the committed query lives in the cubit.
class _SearchField extends fw.StatefulWidget {
  final void Function(String) onChanged;
  const _SearchField({required this.onChanged});

  @override
  fw.State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends fw.State<_SearchField> {
  final _controller = fw.TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      widget.onChanged(value);
    });
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Padding(
      padding: const fw.EdgeInsets.symmetric(
        horizontal: AppDesignTokens.screenPaddingHorizontal,
      ),
      child: TextField(
        controller: _controller,
        placeholder: Text('search_products'.tr()),
        onChanged: _onChanged,
        onSubmitted: (v) {
          _debounce?.cancel();
          widget.onChanged(v);
        },
      ),
    );
  }
}

/// Horizontal row of single-select filter chips: "all" + each category.
class _CategoryFilters extends fw.StatelessWidget {
  final String? selectedCategoryId;
  final void Function(String?) onSelected;

  const _CategoryFilters({
    required this.selectedCategoryId,
    required this.onSelected,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.SizedBox(
      height: 40,
      child: BlocProvider(
        create: (_) => CategoryCubit(),
        child: PaginationList<CategoryModel>(
          withPagination: false,
          withRefresh: false,
          shrinkWrap: true,
          loadingWidget: const fw.Padding(
            padding: fw.EdgeInsets.symmetric(
              horizontal: AppDesignTokens.screenPaddingHorizontal,
            ),
            child: ChipsRowSkeleton(width: 90),
          ),
          repositoryCallBack: (data) {
            return context.read<CategoryCubit>().fetchCategoryList(data);
          },
          listBuilder: (list) {
            return fw.ListView(
              scrollDirection: fw.Axis.horizontal,
              padding: const fw.EdgeInsets.symmetric(
                horizontal: AppDesignTokens.screenPaddingHorizontal,
              ),
              children: [
                _FilterChip(
                  label: 'all'.tr(),
                  isSelected: selectedCategoryId == null,
                  onTap: () => onSelected(null),
                ),
                for (final category in list)
                  if (category.id != null)
                    _FilterChip(
                      label: category.name ?? 'N/A',
                      isSelected: selectedCategoryId == category.id,
                      onTap: () => onSelected(category.id),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterChip extends fw.StatelessWidget {
  final String label;
  final bool isSelected;
  final fw.VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return fw.Padding(
      padding: const fw.EdgeInsetsDirectional.only(end: AppDesignTokens.smallGap),
      child: PressScale(
        onTap: onTap,
        child: fw.Container(
          alignment: fw.Alignment.center,
          padding: const fw.EdgeInsets.symmetric(horizontal: 16),
          decoration: fw.BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : AppDesignTokens.mutedSurfaceColor,
            borderRadius: fw.BorderRadius.circular(AppDesignTokens.pillRadius),
            border: fw.Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.border.withValues(alpha: 0.15),
            ),
          ),
          child: Text(
            label,
            style: fw.TextStyle(
              fontSize: AppDesignTokens.captionFontSize + 1,
              fontWeight: fw.FontWeight.w600,
              color: isSelected
                  ? theme.colorScheme.primaryForeground
                  : theme.colorScheme.foreground,
            ),
          ),
        ),
      ),
    );
  }
}

/// The scrollable product catalog. Reloads whenever its parent BlocProvider is
/// re-keyed (category / search change).
class _CatalogList extends fw.StatelessWidget {
  final String? categoryId;
  final String filter;

  const _CatalogList({required this.categoryId, required this.filter});

  @override
  fw.Widget build(fw.BuildContext context) {
    return PaginationList<ProductModel>(
      withPagination: true,
      withRefresh: false,
      loadingWidget: const SelectorListSkeleton(
        withSubtitle: true,
        padding: fw.EdgeInsets.symmetric(
          horizontal: AppDesignTokens.screenPaddingHorizontal,
        ),
      ),
      noDataWidget: EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'products_empty_title'.tr(),
        subtitle: 'products_empty_subtitle'.tr(),
      ),
      repositoryCallBack: (data) {
        return context.read<ProductCubit>().fetchProductList(
              data,
              categoryId: categoryId,
              filter: filter.isEmpty ? null : filter,
            );
      },
      listBuilder: (list) {
        return fw.ListView.builder(
          padding: const fw.EdgeInsets.fromLTRB(
            AppDesignTokens.screenPaddingHorizontal,
            0,
            AppDesignTokens.screenPaddingHorizontal,
            AppDesignTokens.cardGap,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return fw.Padding(
              padding: const fw.EdgeInsets.only(
                bottom: AppDesignTokens.itemGap,
              ),
              child: _ProductRow(product: list[index]),
            );
          },
        );
      },
    );
  }
}

/// A product row that expands in place to pick a variant and stage a line.
class _ProductRow extends fw.StatelessWidget {
  final ProductModel product;
  const _ProductRow({required this.product});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<AddProductDialogCubit>();
    final productId = product.id ?? '';
    final isExpanded = cubit.expandedProductId == productId;

    return fw.Container(
      decoration: fw.BoxDecoration(
        color: AppDesignTokens.cardColor,
        borderRadius: fw.BorderRadius.circular(AppDesignTokens.cardRadius),
        border: fw.Border.all(
          color: isExpanded
              ? theme.colorScheme.primary
              : theme.colorScheme.border.withValues(alpha: 0.15),
          width: isExpanded ? 1.5 : 1,
        ),
      ),
      clipBehavior: fw.Clip.antiAlias,
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.stretch,
        children: [
          PressScale(
            onTap: productId.isEmpty
                ? () {}
                : () => cubit.toggleExpand(productId),
            child: fw.Padding(
              padding: const fw.EdgeInsets.all(AppDesignTokens.itemGap),
              child: fw.Row(
                children: [
                  fw.ClipRRect(
                    borderRadius:
                        fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
                    child: AuthenticatedImage(
                      imageUrl: ImageHelper.getProductImageUrl(productId),
                      width: 48,
                      height: 48,
                      fit: fw.BoxFit.cover,
                      errorWidget: fw.Container(
                        color: AppDesignTokens.mutedSurfaceColor,
                        child: const fw.Center(
                          child: Icon(Icons.inventory_2_outlined, size: 22),
                        ),
                      ),
                    ),
                  ),
                  const fw.SizedBox(width: AppDesignTokens.itemGap),
                  fw.Expanded(
                    child: fw.Column(
                      crossAxisAlignment: fw.CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name ?? 'N/A',
                          maxLines: 1,
                          overflow: fw.TextOverflow.ellipsis,
                          style: const fw.TextStyle(
                            fontSize: AppDesignTokens.bodyFontSize,
                            fontWeight: AppDesignTokens.semiBold,
                          ),
                        ),
                        const fw.SizedBox(height: 4),
                        fw.Row(
                          children: [
                            _StockDot(stock: product.totalStockQuantity),
                            const fw.SizedBox(width: 6),
                            Text(
                              'stock'.tr(
                                args: ['${product.totalStockQuantity ?? 0}'],
                              ),
                              style: fw.TextStyle(
                                fontSize: AppDesignTokens.captionFontSize,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            _ExpansionBody(productId: productId, productName: product.name),
        ],
      ),
    );
  }
}

class _ExpansionBody extends fw.StatelessWidget {
  final String productId;
  final String? productName;

  const _ExpansionBody({required this.productId, this.productName});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<AddProductDialogCubit>();

    if (cubit.variantsLoading) {
      return const fw.Padding(
        padding: fw.EdgeInsets.all(AppDesignTokens.cardPaddingLarge),
        child: fw.Center(
          child: fw.SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (cubit.variantsError != null) {
      return fw.Padding(
        padding: const fw.EdgeInsets.all(AppDesignTokens.cardPaddingLarge),
        child: Text(
          cubit.variantsError!,
          style: TextStyle(
            fontSize: AppDesignTokens.captionFontSize,
            color: AppDesignTokens.dangerColor,
          ),
        ),
      );
    }

    final variants = cubit.variantsFor(productId) ?? const [];
    if (variants.isEmpty) {
      return fw.Padding(
        padding: const fw.EdgeInsets.all(AppDesignTokens.cardPaddingLarge),
        child: Text(
          'no_variants_for_this_product'.tr(),
          style: fw.TextStyle(
            fontSize: AppDesignTokens.captionFontSize,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      );
    }

    final colors = cubit.availableColors;
    final hasColorChoice = colors.isNotEmpty;
    final sizes = cubit.availableSizes;
    final hasSizeChoice = sizes.isNotEmpty;

    // When there is a real choice to make, show the colour / size pickers.
    final showPickers = variants.length > 1 && (hasColorChoice || hasSizeChoice);
    final resolved = cubit.resolvedVariant;

    return fw.Container(
      width: double.infinity,
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.itemGap,
        0,
        AppDesignTokens.itemGap,
        AppDesignTokens.itemGap,
      ),
      decoration: fw.BoxDecoration(
        color: AppDesignTokens.mutedSurfaceColor.withValues(alpha: 0.4),
      ),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          const fw.SizedBox(height: AppDesignTokens.smallGap),
          if (showPickers) ...[
            if (hasColorChoice) ...[
              _PickerLabel(text: 'choose_color'.tr()),
              const fw.SizedBox(height: AppDesignTokens.smallGap),
              fw.Wrap(
                spacing: AppDesignTokens.smallGap,
                runSpacing: AppDesignTokens.smallGap,
                children: [
                  for (final color in colors)
                    _ChoicePill(
                      label: color,
                      isSelected: cubit.selectedColor == color,
                      onTap: () => cubit.selectColor(color),
                    ),
                ],
              ),
              const fw.SizedBox(height: AppDesignTokens.itemGap),
            ],
            if (hasSizeChoice && (!hasColorChoice || cubit.selectedColor != null)) ...[
              _PickerLabel(text: 'choose_size'.tr()),
              const fw.SizedBox(height: AppDesignTokens.smallGap),
              fw.Wrap(
                spacing: AppDesignTokens.smallGap,
                runSpacing: AppDesignTokens.smallGap,
                children: [
                  for (final size in sizes)
                    _ChoicePill(
                      label: size,
                      isSelected: cubit.selectedSize == size,
                      disabled:
                          (cubit.variantForSize(size)?.stockQuantity ?? 0) <= 0,
                      onTap: () => cubit.selectSize(size),
                    ),
                ],
              ),
              const fw.SizedBox(height: AppDesignTokens.itemGap),
            ],
          ],
          if (resolved != null && (resolved.stockQuantity ?? 0) > 0)
            _StageRow(
              quantity: cubit.stagingQuantity,
              stock: resolved.stockQuantity ?? 0,
              onChange: cubit.changeStagingQuantity,
              onAdd: () => cubit.stageResolved(
                _variantLabel(productName, resolved),
              ),
            )
          else if (resolved != null)
            Text(
              'out_of_stock'.tr(),
              style: TextStyle(
                fontSize: AppDesignTokens.captionFontSize,
                color: AppDesignTokens.dangerColor,
                fontWeight: AppDesignTokens.semiBold,
              ),
            ),
        ],
      ),
    );
  }
}

String _variantLabel(String? productName, ProductVariantModel variant) {
  final name = productName ?? variant.productName ?? 'N/A';
  final attrs = <String>[
    if ((variant.color ?? '').isNotEmpty) variant.color!,
    if ((variant.size ?? '').isNotEmpty) variant.size!,
  ];
  if (attrs.isEmpty) return name;
  return '$name · ${attrs.join(' / ')}';
}

class _PickerLabel extends fw.StatelessWidget {
  final String text;
  const _PickerLabel({required this.text});

  @override
  fw.Widget build(fw.BuildContext context) {
    return Text(
      text,
      style: const fw.TextStyle(
        fontSize: AppDesignTokens.captionFontSize + 1,
        fontWeight: AppDesignTokens.bold,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _ChoicePill extends fw.StatelessWidget {
  final String label;
  final bool isSelected;
  final bool disabled;
  final fw.VoidCallback onTap;

  const _ChoicePill({
    required this.label,
    required this.isSelected,
    this.disabled = false,
    required this.onTap,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final content = fw.Container(
      padding: const fw.EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: fw.BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : AppDesignTokens.cardColor,
        borderRadius: fw.BorderRadius.circular(AppDesignTokens.inputRadius),
        border: fw.Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.border.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: fw.TextStyle(
          fontSize: AppDesignTokens.captionFontSize + 1,
          fontWeight: fw.FontWeight.w600,
          color: isSelected
              ? theme.colorScheme.primaryForeground
              : theme.colorScheme.foreground,
        ),
      ),
    );

    if (disabled) {
      return fw.Opacity(opacity: 0.4, child: content);
    }
    return PressScale(onTap: onTap, child: content);
  }
}

class _StockDot extends fw.StatelessWidget {
  final int? stock;
  const _StockDot({required this.stock});

  @override
  fw.Widget build(fw.BuildContext context) {
    final s = stock ?? 0;
    final color = s <= 0
        ? AppDesignTokens.dangerColor
        : (s <= 5 ? AppDesignTokens.warningColor : AppDesignTokens.successColor);
    return fw.Container(
      width: 8,
      height: 8,
      decoration: fw.BoxDecoration(color: color, shape: fw.BoxShape.circle),
    );
  }
}

/// Quantity stepper + add button shown once a variant resolves with stock.
class _StageRow extends fw.StatelessWidget {
  final int quantity;
  final int stock;
  final void Function(int delta) onChange;
  final fw.VoidCallback onAdd;

  const _StageRow({
    required this.quantity,
    required this.stock,
    required this.onChange,
    required this.onAdd,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return fw.Row(
      children: [
        fw.Container(
          padding: const fw.EdgeInsets.symmetric(horizontal: 4),
          decoration: fw.BoxDecoration(
            color: AppDesignTokens.cardColor,
            borderRadius: fw.BorderRadius.circular(AppDesignTokens.inputRadius),
            border: fw.Border.all(
              color: theme.colorScheme.border.withValues(alpha: 0.2),
            ),
          ),
          child: fw.Row(
            mainAxisSize: fw.MainAxisSize.min,
            children: [
              _StepButton(
                icon: Icons.remove_rounded,
                onTap: () => onChange(-1),
              ),
              fw.SizedBox(
                width: 36,
                child: Text(
                  '$quantity',
                  textAlign: fw.TextAlign.center,
                  style: const fw.TextStyle(
                    fontSize: AppDesignTokens.bodyFontSize + 1,
                    fontWeight: AppDesignTokens.bold,
                  ),
                ),
              ),
              _StepButton(
                icon: Icons.add_rounded,
                onTap: () => onChange(1),
              ),
            ],
          ),
        ),
        const fw.SizedBox(width: AppDesignTokens.itemGap),
        fw.Expanded(
          child: PrimaryButton(
            onPressed: onAdd,
            child: Text('add'.tr()),
          ),
        ),
      ],
    );
  }
}

class _StepButton extends fw.StatelessWidget {
  final fw.IconData icon;
  final fw.VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return fw.GestureDetector(
      onTap: onTap,
      child: fw.Container(
        width: 34,
        height: 34,
        margin: const fw.EdgeInsets.symmetric(vertical: 4),
        decoration: fw.BoxDecoration(
          color: AppDesignTokens.mutedSurfaceColor,
          borderRadius: fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
        ),
        child: Icon(icon, size: 16, color: theme.colorScheme.foreground),
      ),
    );
  }
}

/// Pinned footer: staged tray summary (expandable) + the commit CTA.
class _TrayAndCommit extends fw.StatelessWidget {
  final ThemeData theme;
  final Future<void> Function(String productVariantId, int quantity)
      onItemAdded;

  const _TrayAndCommit({required this.theme, required this.onItemAdded});

  @override
  fw.Widget build(fw.BuildContext context) {
    final cubit = context.read<AddProductDialogCubit>();
    final staged = cubit.staged;
    final hasItems = staged.isNotEmpty;

    return fw.Container(
      decoration: fw.BoxDecoration(
        color: AppDesignTokens.cardColor,
        border: fw.Border(
          top: fw.BorderSide(
            color: theme.colorScheme.border.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: fw.SafeArea(
        top: false,
        child: fw.Padding(
          padding: const fw.EdgeInsets.all(AppDesignTokens.cardPaddingLarge),
          child: fw.Column(
            mainAxisSize: fw.MainAxisSize.min,
            crossAxisAlignment: fw.CrossAxisAlignment.stretch,
            children: [
              if (hasItems) ...[
                if (cubit.trayExpanded)
                  fw.ConstrainedBox(
                    constraints: const fw.BoxConstraints(maxHeight: 180),
                    child: fw.ListView(
                      shrinkWrap: true,
                      children: [
                        for (final entry in staged)
                          _TrayLine(
                            entry: entry,
                            theme: theme,
                            onRemove: () => cubit.removeStaged(entry.variantId),
                          ),
                        const fw.SizedBox(height: AppDesignTokens.smallGap),
                      ],
                    ),
                  ),
                PressScale(
                  onTap: cubit.toggleTray,
                  child: fw.Padding(
                    padding: const fw.EdgeInsets.only(
                      bottom: AppDesignTokens.itemGap,
                    ),
                    child: fw.Row(
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const fw.SizedBox(width: AppDesignTokens.smallGap),
                        fw.Expanded(
                          child: Text(
                            'tray_summary'.tr(
                              args: [
                                '${staged.length}',
                                '${cubit.stagedQuantityTotal}',
                              ],
                            ),
                            style: const fw.TextStyle(
                              fontSize: AppDesignTokens.bodyFontSize,
                              fontWeight: AppDesignTokens.semiBold,
                            ),
                          ),
                        ),
                        Icon(
                          cubit.trayExpanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              PrimaryButton(
                onPressed: (!hasItems || cubit.committing)
                    ? null
                    : () => _commit(context, cubit),
                child: Text('add_to_order'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _commit(
    fw.BuildContext context,
    AddProductDialogCubit cubit,
  ) async {
    cubit.setCommitting(true);
    final entries = List.of(cubit.staged);
    for (final entry in entries) {
      await onItemAdded(entry.variantId, entry.quantity);
    }
    if (!context.mounted) return;
    fw.Navigator.pop(context);
  }
}

class _TrayLine extends fw.StatelessWidget {
  final StagedEntry entry;
  final ThemeData theme;
  final fw.VoidCallback onRemove;

  const _TrayLine({
    required this.entry,
    required this.theme,
    required this.onRemove,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Padding(
      padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.smallGap),
      child: fw.Row(
        children: [
          fw.Container(
            padding: const fw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: fw.BoxDecoration(
              color: AppDesignTokens.mutedSurfaceColor,
              borderRadius: fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
            ),
            child: Text(
              '${entry.quantity}×',
              style: const fw.TextStyle(
                fontSize: AppDesignTokens.captionFontSize,
                fontWeight: AppDesignTokens.bold,
              ),
            ),
          ),
          const fw.SizedBox(width: AppDesignTokens.smallGap),
          fw.Expanded(
            child: Text(
              entry.label,
              maxLines: 1,
              overflow: fw.TextOverflow.ellipsis,
              style: const fw.TextStyle(
                fontSize: AppDesignTokens.captionFontSize + 1,
              ),
            ),
          ),
          fw.GestureDetector(
            onTap: onRemove,
            child: fw.Padding(
              padding: const fw.EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
