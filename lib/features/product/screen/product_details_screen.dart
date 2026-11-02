import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../../core/ui/dialogs/action_helpers.dart';
import '../../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/product_cubit.dart';
import '../data/model/product_model.dart';
import 'update_product_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../product_variant/data/model/product_variant_model.dart';
import '../../product_variant/data/repository/product_variant_repository.dart';
import '../../product_variant/data/usecase/get_product_variant_list_usecase.dart';
import 'package:store/core/ui/shadcn/widget/design_system/app_skeleton_loader.dart';

/// Product Details Screen - Shows complete product information
class ProductDetailsScreen extends fw.StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => ProductCubit(),
      child: Scaffold(
        child: SafeArea(
          child: GetModel<ProductModel>(
            useCaseCallBack: () =>
                context.read<ProductCubit>().getProductDetails(productId),
            modelBuilder: (product) {
              final imageUrl = ImageHelper.getProductImageUrl(product.id ?? '');

              return ScrollAwayHeader(header: fw.Column(children: [
                  // App Bar
                  Container(
                    padding: const fw.EdgeInsets.fromLTRB(16, 16, 20, 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.border.withValues(
                            alpha: 0.1,
                          ),
                          width: 1,
                        ),
                      ),
                    ),
                    child: fw.Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.muted.withValues(
                              alpha: 0.3,
                            ),
                            borderRadius: fw.BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, size: 20),
                            onPressed: () => fw.Navigator.of(context).pop(),
                            variance: ButtonVariance.ghost,
                          ),
                        ),
                        const fw.SizedBox(width: 12),
                        fw.Expanded(
                          child: Text(
                            'product_details'.tr(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => showConfirmDialog(
                            context,
                            title: 'delete_product'.tr(),
                            message: 'delete_it_can_be_restored_later_from_d'.tr(args: ['${product.name ?? 'this product'}']),
                            confirmLabel: 'delete'.tr(),
                            destructive: true,
                            onConfirm: () async {
                              final deleted = await runRemoteAction(
                                () => context.read<ProductCubit>().deleteProduct(
                                  productId,
                                ),
                                successMessage: 'product_deleted'.tr(),
                              );
                              if (deleted && context.mounted) {
                                fw.Navigator.of(context).pop(true);
                              }
                            },
                          ),
                          variance: ButtonVariance.ghost,
                        ),
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () async {
                            final result = await fw.Navigator.of(context).push(
                              fw.PageRouteBuilder(
                                pageBuilder: (_, __, ___) => BlocProvider.value(
                                  value: context.read<ProductCubit>(),
                                  child: UpdateProductScreen(product: product),
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );

                            // Refresh details if product was updated
                            if (result != null && context.mounted) {
                              context.read<ProductCubit>().getProductDetails(
                                productId,
                              );
                            }
                          },
                          variance: ButtonVariance.ghost,
                        ),
                      ],
                    ),
                  )]), body: fw.SingleChildScrollView(
                      padding: const fw.EdgeInsets.all(20),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          Container(
                            width: double.infinity,
                            height: 280,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.muted.withValues(
                                alpha: 0.3,
                              ),
                              borderRadius: fw.BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.colorScheme.border.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: fw.ClipRRect(
                              borderRadius: fw.BorderRadius.circular(20),
                              child: AuthenticatedImage(
                                imageUrl: imageUrl,
                                width: double.infinity,
                                height: 280,
                                fit: fw.BoxFit.cover,
                                errorWidget: Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.muted.withValues(
                                      alpha: 0.3,
                                    ),
                                    borderRadius: fw.BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    color: theme.colorScheme.mutedForeground,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const fw.SizedBox(height: 24),

                          // Product Name
                          Text(
                            product.name ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const fw.SizedBox(height: 12),

                          // Price & Status Row
                          fw.Row(
                            children: [
                              fw.Expanded(
                                child: Container(
                                  padding: const fw.EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: fw.BorderRadius.circular(12),
                                    border: Border.all(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: fw.Column(
                                    crossAxisAlignment:
                                        fw.CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'price'.tr(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              theme.colorScheme.mutedForeground,
                                        ),
                                      ),
                                      const fw.SizedBox(height: 4),
                                      Text(
                                        '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const fw.SizedBox(width: 12),
                              Container(
                                padding: const fw.EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: product.isActive == true
                                      ? theme.colorScheme.primary.withValues(
                                          alpha: 0.1,
                                        )
                                      : theme.colorScheme.muted.withValues(
                                          alpha: 0.3,
                                        ),
                                  borderRadius: fw.BorderRadius.circular(12),
                                  border: Border.all(
                                    color: product.isActive == true
                                        ? theme.colorScheme.primary.withValues(
                                            alpha: 0.3,
                                          )
                                        : theme.colorScheme.border.withValues(
                                            alpha: 0.3,
                                          ),
                                    width: 1,
                                  ),
                                ),
                                child: fw.Column(
                                  children: [
                                    Text(
                                      'status'.tr(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 4),
                                    Text(
                                      product.isActive == true
                                          ? 'active'.tr()
                                          : 'inactive'.tr(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: product.isActive == true
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const fw.SizedBox(height: 24),

                          // Description Section
                          if (product.description != null &&
                              product.description!.isNotEmpty) ...[
                            Text(
                              'description'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const fw.SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.card,
                                borderRadius: fw.BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.border.withValues(
                                    alpha: 0.5,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                product.description!,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: theme.colorScheme.foreground,
                                ),
                              ),
                            ),
                            const fw.SizedBox(height: 24),
                          ],

                          _StockBreakdown(productId: product.id ?? ''),
                          const fw.SizedBox(height: 24),

                          // Details Section
                          Text(
                            'details'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const fw.SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const fw.EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.card,
                              borderRadius: fw.BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.border.withValues(
                                  alpha: 0.5,
                                ),
                                width: 1,
                              ),
                            ),
                            child: fw.Column(
                              children: [
                                _DetailRow(
                                  label: 'category'.tr(),
                                  value: product.category?.name ?? 'N/A',
                                  theme: theme,
                                ),
                                const fw.SizedBox(height: 16),
                                _DetailRow(
                                  label: 'stock_quantity'.tr(),
                                  value:
                                      product.totalStockQuantity?.toString() ??
                                      '0',
                                  theme: theme,
                                ),
                                const fw.SizedBox(height: 16),
                                _DetailRow(
                                  label: 'availability'.tr(),
                                  value:
                                      product.availabilityStatus?.name ?? 'N/A',
                                  theme: theme,
                                ),
                                const fw.SizedBox(height: 16),
                                _DetailRow(
                                  label: 'target_audience'.tr(),
                                  value: product.targetAudience?.name ?? 'N/A',
                                  theme: theme,
                                ),
                                if (product.creationTime != null) ...[
                                  const fw.SizedBox(height: 16),
                                  _DetailRow(
                                    label: 'created'.tr(),
                                    value: _formatDate(product.creationTime!),
                                    theme: theme,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends fw.StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        fw.Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ),
        fw.Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.foreground,
            ),
          ),
        ),
      ],
    );
  }
}

/// Stock overview: total pieces, colors and pieces per color/size,
/// built from all variants of the product.
class _StockBreakdown extends fw.StatefulWidget {
  final String productId;
  const _StockBreakdown({required this.productId});

  @override
  fw.State<_StockBreakdown> createState() => _StockBreakdownState();
}

class _StockBreakdownState extends fw.State<_StockBreakdown> {
  List<ProductVariantModel>? _variants;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await GetProductVariantListUsecase(
      ProductVariantRepository(),
    ).call(
      params: GetProductVariantListParams(
        request: GetListRequest(skip: 0, take: 1000),
        productId: widget.productId,
      ),
    );
    if (!mounted) return;
    setState(() {
      _variants = result.data;
      _failed = result.data == null;
    });
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    fw.Widget title() => Text(
      'stock_overview'.tr(),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    );

    if (_variants == null && !_failed) {
      return fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          title(),
          const fw.SizedBox(height: 12),
          const AppSkeletonBox(width: double.infinity, height: 90, borderRadius: 20),
          const fw.SizedBox(height: 12),
          const AppSkeletonBox(width: double.infinity, height: 110, borderRadius: 20),
        ],
      );
    }
    if (_failed) return const fw.SizedBox.shrink();

    final variants = _variants!;
    if (variants.isEmpty) {
      return fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          title(),
          const fw.SizedBox(height: 12),
          fw.Container(
            width: double.infinity,
            padding: const fw.EdgeInsets.all(16),
            decoration: fw.BoxDecoration(
              color: theme.colorScheme.card,
              borderRadius: fw.BorderRadius.circular(20),
            ),
            child: Text(
              'no_variants_yet'.tr(),
              style: TextStyle(color: theme.colorScheme.mutedForeground),
            ),
          ),
        ],
      );
    }

    // color -> (size -> qty)
    final byColor = <String, Map<String, int>>{};
    var total = 0;
    for (final v in variants) {
      final color = (v.color ?? '').trim();
      final size = (v.size ?? '').trim();
      final qty = v.stockQuantity ?? 0;
      total += qty;
      final m = byColor.putIfAbsent(color, () => {});
      m[size] = (m[size] ?? 0) + qty;
    }
    final colorCount = byColor.keys.where((c) => c.isNotEmpty).length;

    fw.Widget stat(String label, String value) => fw.Expanded(
      child: fw.Container(
        padding: const fw.EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: fw.BoxDecoration(
          color: theme.colorScheme.card,
          borderRadius: fw.BorderRadius.circular(20),
        ),
        child: fw.Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
            const fw.SizedBox(height: 2),
            Text(
              label,
              textAlign: fw.TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );

    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        title(),
        const fw.SizedBox(height: 12),
        fw.Row(
          children: [
            stat('total_pieces'.tr(), '$total'),
            const fw.SizedBox(width: 10),
            if (colorCount > 0) ...[
              stat('colors_count'.tr(), '$colorCount'),
              const fw.SizedBox(width: 10),
            ],
            stat('variants_count'.tr(), '${variants.length}'),
          ],
        ),
        const fw.SizedBox(height: 12),
        for (final entry in byColor.entries) ...[
          fw.Container(
            width: double.infinity,
            padding: const fw.EdgeInsets.all(16),
            decoration: fw.BoxDecoration(
              color: theme.colorScheme.card,
              borderRadius: fw.BorderRadius.circular(20),
            ),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                fw.Row(
                  children: [
                    fw.Expanded(
                      child: Text(
                        entry.key.isEmpty ? 'no_color'.tr() : entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      'pieces_count'.tr(
                        args: ['${entry.value.values.fold<int>(0, (a, b) => a + b)}'],
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                if (entry.value.keys.any((k) => k.isNotEmpty)) ...[
                  const fw.SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final sz in entry.value.entries)
                        if (sz.key.isNotEmpty)
                          fw.Container(
                            padding: const fw.EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: fw.BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: fw.BorderRadius.circular(99),
                            ),
                            child: Text(
                              '${sz.key}  ×${sz.value}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const fw.SizedBox(height: 10),
        ],
      ],
    );
  }
}
