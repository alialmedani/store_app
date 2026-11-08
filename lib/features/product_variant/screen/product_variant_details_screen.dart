import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../core/ui/dialogs/action_helpers.dart';
import '../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/model/product_variant_model.dart';
import 'update_product_variant_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';

/// Product Variant Details Screen - Shows complete product variant information
class ProductVariantDetailsScreen extends fw.StatelessWidget {
  final String productVariantId;

  const ProductVariantDetailsScreen({
    super.key,
    required this.productVariantId,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    Theme.of(context);

    return BlocProvider(
      create: (context) => ProductVariantCubit(),
      child: Scaffold(
        child: SafeArea(
          child: GetModel<ProductVariantModel>(
            useCaseCallBack: () => context
                .read<ProductVariantCubit>()
                .getProductVariantDetails(productVariantId),
            modelBuilder: (variant) {
              return ScrollAwayHeader(header: fw.Column(children: [
                  AppHeader(
                    title: 'variant_details'.tr(),
                    action: fw.Row(
                      mainAxisSize: fw.MainAxisSize.min,
                      children: [
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => showConfirmDialog(
                            context,
                            title: 'delete_variant'.tr(),
                            message: 'delete_variant_it_can_be_restored_late'.tr(args: ['${variant.color ?? ''}', '${variant.size ?? ''}']),
                            confirmLabel: 'delete'.tr(),
                            destructive: true,
                            onConfirm: () async {
                              final deleted = await runRemoteAction(
                                () => context.read<ProductVariantCubit>().deleteProductVariant(
                                  productVariantId,
                                ),
                                successMessage: 'variant_deleted'.tr(),
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
                                  value: context.read<ProductVariantCubit>(),
                                  child: UpdateProductVariantScreen(
                                    variant: variant,
                                  ),
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );

                            // Refresh details if variant was updated
                            if (result != null && context.mounted) {
                              // Trigger a rebuild by calling the details API again
                              context
                                  .read<ProductVariantCubit>()
                                  .getProductVariantDetails(productVariantId);
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
                          // Hero: product name on the Aurora gradient
                          fw.Container(
                            width: double.infinity,
                            padding: const fw.EdgeInsets.all(20),
                            decoration: fw.BoxDecoration(
                              gradient: AppDesignTokens.primaryGradient,
                              borderRadius: fw.BorderRadius.circular(
                                AppDesignTokens.cardRadius + 4,
                              ),
                              boxShadow: AppDesignTokens.glowShadow,
                            ),
                            child: fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                fw.Text(
                                  'product'.tr(),
                                  style: fw.TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: fw.FontWeight.w600,
                                    color: const fw.Color(0xFFFFFFFF)
                                        .withValues(alpha: 0.78),
                                  ),
                                ),
                                const fw.SizedBox(height: 6),
                                fw.Text(
                                  variant.productName ?? 'N/A',
                                  style: const fw.TextStyle(
                                    fontSize: 24,
                                    fontWeight: fw.FontWeight.w800,
                                    letterSpacing: -0.4,
                                    color: fw.Color(0xFFFFFFFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const fw.SizedBox(height: 16),

                          // Color / size
                          if ((variant.color ?? '').isNotEmpty ||
                              (variant.size ?? '').isNotEmpty) ...[
                            fw.IntrinsicHeight(
                              child: fw.Row(
                                crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                                children: [
                                  if ((variant.color ?? '').isNotEmpty)
                                    fw.Expanded(
                                      child: AppStatTile(
                                        label: 'color'.tr(),
                                        value: variant.color!,
                                        icon: Icons.palette_rounded,
                                      ),
                                    ),
                                  if ((variant.color ?? '').isNotEmpty &&
                                      (variant.size ?? '').isNotEmpty)
                                    const fw.SizedBox(width: 12),
                                  if ((variant.size ?? '').isNotEmpty)
                                    fw.Expanded(
                                      child: AppStatTile(
                                        label: 'size'.tr(),
                                        value: variant.size!,
                                        icon: Icons.straighten_rounded,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const fw.SizedBox(height: 12),
                          ],

                          // Stock & status
                          fw.IntrinsicHeight(
                            child: fw.Row(
                              crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                              children: [
                                fw.Expanded(
                                  child: AppStatTile(
                                    label: 'stock_2'.tr(),
                                    value:
                                        variant.stockQuantity?.toString() ?? '0',
                                    icon: Icons.inventory_2_rounded,
                                    highlight: true,
                                  ),
                                ),
                                const fw.SizedBox(width: 12),
                                fw.Expanded(
                                  child: AppStatTile(
                                    label: 'status'.tr(),
                                    value: variant.isActive == true
                                        ? 'active'.tr()
                                        : 'inactive'.tr(),
                                    icon: variant.isActive == true
                                        ? Icons.check_circle_rounded
                                        : Icons.pause_circle_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const fw.SizedBox(height: 24),

                          AppSectionTitle('details'.tr()),
                          const fw.SizedBox(height: 12),
                          AppInfoSection(
                            children: [
                              AppInfoRow(
                                icon: Icons.tag_rounded,
                                label: 'product_id'.tr(),
                                value: variant.productId ?? 'N/A',
                              ),
                              AppInfoRow(
                                icon: Icons.verified_rounded,
                                label: 'availability'.tr(),
                                value: variant.availabilityStatus?.name ?? 'N/A',
                              ),
                              if (variant.creationTime != null)
                                AppInfoRow(
                                  icon: Icons.calendar_today_rounded,
                                  label: 'created'.tr(),
                                  value: _formatDate(variant.creationTime!),
                                ),
                              if (variant.lastModificationTime != null)
                                AppInfoRow(
                                  icon: Icons.update_rounded,
                                  label: 'last_modified'.tr(),
                                  value: _formatDate(variant.lastModificationTime!),
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
