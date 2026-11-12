import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/model/product_variant_model.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

/// Update Product Variant Screen - Form to update existing product variant
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class UpdateProductVariantScreen extends fw.StatefulWidget {
  final ProductVariantModel variant;

  const UpdateProductVariantScreen({super.key, required this.variant});

  @override
  fw.State<UpdateProductVariantScreen> createState() =>
      _UpdateProductVariantScreenState();
}

class _UpdateProductVariantScreenState
    extends fw.State<UpdateProductVariantScreen> {
  final _colorController = fw.TextEditingController();
  final _sizeController = fw.TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProductVariantCubit>();

    // Initialize params with existing variant data
    cubit.updateProductVariantParams.productVariantId = widget.variant.id ?? '';
    cubit.updateProductVariantParams.color = widget.variant.color;
    cubit.updateProductVariantParams.size = widget.variant.size;
    cubit.updateProductVariantParams.isActive = widget.variant.isActive ?? true;

    // Initialize text controllers
    _colorController.text = widget.variant.color ?? '';
    _sizeController.text = widget.variant.size ?? '';
  }

  @override
  void dispose() {
    _colorController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final cubit = context.read<ProductVariantCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: ScrollAwayHeader(header: fw.Column(children: [
            AppHeader(
              title: 'update_product_variant'.tr(),
              onBack: () => fw.Navigator.of(context).pop(),
            ),
          ]), body: fw.SingleChildScrollView(
                padding: const fw.EdgeInsets.all(
                  AppDesignTokens.screenPaddingHorizontal,
                ),
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                  children: [
                    // Product section (read-only)
                    AppCard(
                      elevated: true,
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          Text(
                            'product'.tr(),
                            style: const TextStyle(
                              fontSize: AppDesignTokens.bodyFontSize,
                              fontWeight: AppDesignTokens.semiBold,
                            ),
                          ),
                          const fw.SizedBox(height: AppDesignTokens.smallGap),
                          Container(
                            width: double.infinity,
                            padding: const fw.EdgeInsets.all(AppDesignTokens.itemGap),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.muted.withValues(
                                alpha: 0.3,
                              ),
                              borderRadius: fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
                              border: Border.all(
                                color: theme.colorScheme.border,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.variant.productName ?? 'N/A',
                              style: TextStyle(
                                fontSize: AppDesignTokens.bodyFontSize,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.cardGap),

                    // Variant details section
                    AppCard(
                      elevated: true,
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'variant_details'.tr(),
                            style: const TextStyle(
                              fontSize: AppDesignTokens.cardTitleFontSize,
                              fontWeight: AppDesignTokens.bold,
                            ),
                          ),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),

                          // Color Field
                          BlocBuilder<ProductVariantCubit, ProductVariantState>(
                            builder: (context, state) {
                              return fw.Column(
                                crossAxisAlignment: fw.CrossAxisAlignment.start,
                                children: [
                                  fw.Row(
                                    children: [
                                      Text(
                                        'color'.tr(),
                                        style: const TextStyle(
                                          fontSize: AppDesignTokens.bodyFontSize,
                                          fontWeight: AppDesignTokens.semiBold,
                                        ),
                                      ),
                                      const fw.SizedBox(width: AppDesignTokens.smallGap),
                                      Text(
                                        'optional'.tr(),
                                        style: TextStyle(
                                          fontSize: AppDesignTokens.captionFontSize,
                                          color:
                                              theme.colorScheme.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const fw.SizedBox(height: AppDesignTokens.smallGap),
                                  TextField(
                                    controller: _colorController,
                                    placeholder: Text(
                                      'enter_color_optional'.tr(),
                                    ),
                                    onChanged: (value) {
                                      cubit.updateProductVariantParams.color =
                                          value.isEmpty ? null : value;
                                      cubit.clearColorError();
                                    },
                                  ),
                                  if (cubit.colorError != null)
                                    Padding(
                                      padding: const fw.EdgeInsets.only(
                                        top: AppDesignTokens.tinyGap,
                                      ),
                                      child: Text(
                                        cubit.colorError!,
                                        style: TextStyle(
                                          color: AppDesignTokens.dangerColor,
                                          fontSize: AppDesignTokens.captionFontSize,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),

                          // Size Field
                          BlocBuilder<ProductVariantCubit, ProductVariantState>(
                            builder: (context, state) {
                              return fw.Column(
                                crossAxisAlignment: fw.CrossAxisAlignment.start,
                                children: [
                                  fw.Row(
                                    children: [
                                      Text(
                                        'size'.tr(),
                                        style: const TextStyle(
                                          fontSize: AppDesignTokens.bodyFontSize,
                                          fontWeight: AppDesignTokens.semiBold,
                                        ),
                                      ),
                                      const fw.SizedBox(width: AppDesignTokens.smallGap),
                                      Text(
                                        'optional'.tr(),
                                        style: TextStyle(
                                          fontSize: AppDesignTokens.captionFontSize,
                                          color:
                                              theme.colorScheme.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const fw.SizedBox(height: AppDesignTokens.smallGap),
                                  TextField(
                                    controller: _sizeController,
                                    placeholder: Text(
                                      'enter_size_optional'.tr(),
                                    ),
                                    onChanged: (value) {
                                      cubit.updateProductVariantParams.size =
                                          value.isEmpty ? null : value;
                                      cubit.clearSizeError();
                                    },
                                  ),
                                  if (cubit.sizeError != null)
                                    Padding(
                                      padding: const fw.EdgeInsets.only(
                                        top: AppDesignTokens.tinyGap,
                                      ),
                                      child: Text(
                                        cubit.sizeError!,
                                        style: TextStyle(
                                          color: AppDesignTokens.dangerColor,
                                          fontSize: AppDesignTokens.captionFontSize,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),

                          // Is Active Toggle
                          BlocBuilder<ProductVariantCubit, ProductVariantState>(
                            builder: (context, state) {
                              return fw.Row(
                                children: [
                                  fw.Expanded(
                                    child: Text(
                                      'active'.tr(),
                                      style: const TextStyle(
                                        fontSize: AppDesignTokens.bodyFontSize,
                                        fontWeight: AppDesignTokens.semiBold,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value:
                                        cubit.updateProductVariantParams.isActive,
                                    onChanged: (value) {
                                      cubit.toggleUpdateIsActive(value);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.sectionGap),

                    // Submit Button
                    CreateModel<ProductVariantModel>(
                          withValidation: true,
                          onTap: () {
                            // No validation needed - all fields are optional
                            cubit.clearAllErrors();
                            return true;
                          },
                          useCaseCallBack: (data) {
                            return cubit.updateProductVariant();
                          },
                          onSuccess: (variant) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('success'.tr()),
                                content: Text(
                                  'product_variant_updated_successfully'.tr(),
                                ),
                                actions: [
                                  PrimaryButton(
                                    child: Text('ok'.tr()),
                                    onPressed: () {
                                      fw.Navigator.of(ctx).pop();
                                      fw.Navigator.of(context).pop(variant);
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
                            child: Text('update_product_variant'.tr()),
                          ),
                        ),
                  ],
                ),
              )),
      ),
    );
  }
}
