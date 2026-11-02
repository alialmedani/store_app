import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../../core/ui/dialogs/action_helpers.dart';
import '../../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/ui/widgets/image_viewer.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/product_cubit.dart';
import '../data/model/product_model.dart';
import 'update_product_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../product_variant/data/model/product_variant_model.dart';
import '../../product_variant/data/repository/product_variant_repository.dart';
import '../../product_variant/data/usecase/get_product_variant_list_usecase.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';

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
                  AppHeader(
                    title: 'product_details'.tr(),
                    action: fw.Row(
                      mainAxisSize: fw.MainAxisSize.min,
                      children: [
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
                          // Hero image
                          fw.GestureDetector(
                            onTap: () => showImageViewer(context, imageUrl),
                            child: fw.Container(
                            width: double.infinity,
                            height: 300,
                            decoration: fw.BoxDecoration(
                              borderRadius: fw.BorderRadius.circular(
                                AppDesignTokens.cardRadius + 4,
                              ),
                              boxShadow: AppDesignTokens.glowShadow,
                            ),
                            child: fw.ClipRRect(
                              borderRadius: fw.BorderRadius.circular(
                                AppDesignTokens.cardRadius + 4,
                              ),
                              child: fw.Stack(
                                fit: fw.StackFit.expand,
                                children: [
                                  fw.DecoratedBox(
                                    decoration: fw.BoxDecoration(
                                      color: AppDesignTokens.mutedSurfaceColor,
                                    ),
                                    child: fw.Center(
                                      child: fw.Icon(
                                        Icons.inventory_2_outlined,
                                        color: AppDesignTokens.mutedTextColor,
                                        size: 72,
                                      ),
                                    ),
                                  ),
                                  AuthenticatedImage(
                                    imageUrl: imageUrl,
                                    width: double.infinity,
                                    height: 300,
                                    fit: fw.BoxFit.cover,
                                    errorWidget: const fw.SizedBox.shrink(),
                                  ),
                                  fw.DecoratedBox(
                                    decoration: fw.BoxDecoration(
                                      gradient: fw.LinearGradient(
                                        begin: fw.Alignment.center,
                                        end: fw.Alignment.bottomCenter,
                                        colors: [
                                          const fw.Color(0x00000000),
                                          const fw.Color(0xFF0B0D24)
                                              .withValues(alpha: 0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  fw.Positioned(
                                    left: 18,
                                    right: 18,
                                    bottom: 16,
                                    child: fw.Column(
                                      crossAxisAlignment:
                                          fw.CrossAxisAlignment.start,
                                      children: [
                                        fw.Text(
                                          product.name ?? 'N/A',
                                          maxLines: 2,
                                          overflow: fw.TextOverflow.ellipsis,
                                          style: const fw.TextStyle(
                                            fontSize: 24,
                                            fontWeight: fw.FontWeight.w800,
                                            letterSpacing: -0.4,
                                            color: fw.Color(0xFFFFFFFF),
                                          ),
                                        ),
                                        if (product.category?.name != null) ...[
                                          const fw.SizedBox(height: 4),
                                          fw.Text(
                                            product.category!.name!,
                                            style: fw.TextStyle(
                                              fontSize: 13,
                                              fontWeight: fw.FontWeight.w600,
                                              color: const fw.Color(0xFFFFFFFF)
                                                  .withValues(alpha: 0.78),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                          const fw.SizedBox(height: 16),

                          // Price & status
                          fw.Row(
                            children: [
                              fw.Expanded(
                                flex: 3,
                                child: AppStatTile(
                                  label: 'price'.tr(),
                                  value:
                                      '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                  icon: Icons.sell_rounded,
                                  highlight: true,
                                ),
                              ),
                              const fw.SizedBox(width: 12),
                              fw.Expanded(
                                flex: 2,
                                child: AppStatTile(
                                  label: 'status'.tr(),
                                  value: product.isActive == true
                                      ? 'active'.tr()
                                      : 'inactive'.tr(),
                                  icon: product.isActive == true
                                      ? Icons.check_circle_rounded
                                      : Icons.pause_circle_rounded,
                                ),
                              ),
                            ],
                          ),
                          const fw.SizedBox(height: 24),

                          // Description
                          if (product.description != null &&
                              product.description!.isNotEmpty) ...[
                            AppSectionTitle('description'.tr()),
                            const fw.SizedBox(height: 12),
                            fw.Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(16),
                              decoration: AppDesignTokens.glassDecoration(),
                              child: Text(
                                product.description!,
                                style: fw.TextStyle(
                                  fontSize: 14.5,
                                  height: 1.65,
                                  color: AppDesignTokens.titleTextColor.withValues(alpha: 0.88),
                                ),
                              ),
                            ),
                            const fw.SizedBox(height: 24),
                          ],

                          _StockBreakdown(productId: product.id ?? ''),
                          const fw.SizedBox(height: 24),

                          // Details
                          AppSectionTitle('details'.tr()),
                          const fw.SizedBox(height: 12),
                          AppInfoSection(
                            children: [
                              AppInfoRow(
                                icon: Icons.category_rounded,
                                label: 'category'.tr(),
                                value: product.category?.name ?? 'N/A',
                              ),
                              AppInfoRow(
                                icon: Icons.inventory_2_rounded,
                                label: 'stock_quantity'.tr(),
                                value:
                                    product.totalStockQuantity?.toString() ??
                                    '0',
                              ),
                              AppInfoRow(
                                icon: Icons.verified_rounded,
                                label: 'availability'.tr(),
                                value:
                                    product.availabilityStatus?.name ?? 'N/A',
                              ),
                              AppInfoRow(
                                icon: Icons.groups_rounded,
                                label: 'target_audience'.tr(),
                                value: product.targetAudience?.name ?? 'N/A',
                              ),
                              if (product.creationTime != null)
                                AppInfoRow(
                                  icon: Icons.calendar_today_rounded,
                                  label: 'created'.tr(),
                                  value: _formatDate(product.creationTime!),
                                ),
                            ],
                          ),
                          const fw.SizedBox(height: 24),
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

    fw.Widget title() => AppSectionTitle('stock_overview'.tr());

    if (_variants == null && !_failed) {
      return fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          title(),
          const fw.SizedBox(height: 12),
          fw.Row(
            children: const [
              fw.Expanded(
                child: AppSkeletonBox(width: double.infinity, height: 92, borderRadius: 20),
              ),
              fw.SizedBox(width: 10),
              fw.Expanded(
                child: AppSkeletonBox(width: double.infinity, height: 92, borderRadius: 20),
              ),
              fw.SizedBox(width: 10),
              fw.Expanded(
                child: AppSkeletonBox(width: double.infinity, height: 92, borderRadius: 20),
              ),
            ],
          ),
          const fw.SizedBox(height: 12),
          const AppSkeletonBox(width: double.infinity, height: 96, borderRadius: 24),
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
            decoration: AppDesignTokens.glassDecoration(),
            child: Text(
              'no_variants_yet'.tr(),
              style: fw.TextStyle(color: AppDesignTokens.mutedTextColor),
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

    fw.Widget stat(String label, String value, IconData icon, {bool hi = false}) =>
        fw.Expanded(
          child: AppStatTile(label: label, value: value, icon: icon, highlight: hi),
        );

    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        title(),
        const fw.SizedBox(height: 12),
        fw.IntrinsicHeight(
          child: fw.Row(
            crossAxisAlignment: fw.CrossAxisAlignment.stretch,
            children: [
              stat('total_pieces'.tr(), '$total', Icons.inventory_2_rounded, hi: true),
              const fw.SizedBox(width: 10),
              if (colorCount > 0) ...[
                stat('colors_count'.tr(), '$colorCount', Icons.palette_rounded),
                const fw.SizedBox(width: 10),
              ],
              stat('variants_count'.tr(), '${variants.length}', Icons.style_rounded),
            ],
          ),
        ),
        const fw.SizedBox(height: 12),
        for (final entry in byColor.entries) ...[
          fw.Container(
            width: double.infinity,
            padding: const fw.EdgeInsets.all(16),
            decoration: AppDesignTokens.glassDecoration(),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                fw.Row(
                  children: [
                    fw.Container(
                      width: 10,
                      height: 10,
                      decoration: const fw.BoxDecoration(
                        gradient: AppDesignTokens.primaryGradient,
                        shape: fw.BoxShape.circle,
                      ),
                    ),
                    const fw.SizedBox(width: 10),
                    fw.Expanded(
                      child: Text(
                        entry.key.isEmpty ? 'no_color'.tr() : entry.key,
                        style: fw.TextStyle(
                          fontSize: 15.5,
                          fontWeight: AppDesignTokens.bold,
                          color: AppDesignTokens.titleTextColor,
                        ),
                      ),
                    ),
                    fw.Container(
                      padding: const fw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: fw.BoxDecoration(
                        color: AppDesignTokens.primaryColor.withValues(alpha: 0.14),
                        borderRadius: fw.BorderRadius.circular(
                          AppDesignTokens.badgeRadius,
                        ),
                      ),
                      child: Text(
                        'pieces_count'.tr(
                          args: ['${entry.value.values.fold<int>(0, (a, b) => a + b)}'],
                        ),
                        style: fw.TextStyle(
                          fontSize: 12.5,
                          fontWeight: AppDesignTokens.bold,
                          color: AppDesignTokens.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (entry.value.keys.any((k) => k.isNotEmpty)) ...[
                  const fw.SizedBox(height: 12),
                  fw.Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final sz in entry.value.entries)
                        if (sz.key.isNotEmpty)
                          fw.Container(
                            padding: const fw.EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: fw.BoxDecoration(
                              color: AppDesignTokens.mutedSurfaceColor,
                              borderRadius: fw.BorderRadius.circular(
                                AppDesignTokens.badgeRadius + 2,
                              ),
                            ),
                            child: fw.Row(
                              mainAxisSize: fw.MainAxisSize.min,
                              children: [
                                Text(
                                  sz.key,
                                  style: fw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: AppDesignTokens.bold,
                                    color: AppDesignTokens.titleTextColor,
                                  ),
                                ),
                                const fw.SizedBox(width: 6),
                                Text(
                                  '×${sz.value}',
                                  style: fw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: AppDesignTokens.bold,
                                    color: AppDesignTokens.primaryColor,
                                  ),
                                ),
                              ],
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
