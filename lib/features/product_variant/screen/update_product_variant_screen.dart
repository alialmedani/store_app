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
            // App Bar
            Padding(
              padding: const fw.EdgeInsets.all(16),
              child: fw.Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => fw.Navigator.of(context).pop(),
                    variance: ButtonVariance.ghost,
                  ),
                  const fw.SizedBox(width: 8),
                  fw.Expanded(
                    child: Text(
                      'update_product_variant'.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )]), body: fw.SingleChildScrollView(
                padding: const fw.EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const fw.EdgeInsets.all(24),
                    child: fw.Column(
                      crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                      children: [
                        // Product Name (Read-only)
                        fw.Column(
                          crossAxisAlignment: fw.CrossAxisAlignment.start,
                          children: [
                            Text(
                              'product'.tr(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const fw.SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.muted.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: fw.BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.border,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.variant.productName ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const fw.SizedBox(height: 16),

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
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const fw.SizedBox(width: 8),
                                    Text(
                                      'optional'.tr(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                                const fw.SizedBox(height: 8),
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
                                    padding: const fw.EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.colorError!,
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const fw.SizedBox(height: 16),

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
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const fw.SizedBox(width: 8),
                                    Text(
                                      'optional'.tr(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                                const fw.SizedBox(height: 8),
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
                                    padding: const fw.EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.sizeError!,
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const fw.SizedBox(height: 16),

                        // Is Active Toggle
                        BlocBuilder<ProductVariantCubit, ProductVariantState>(
                          builder: (context, state) {
                            return fw.Row(
                              children: [
                                fw.Expanded(
                                  child: Text(
                                    'active'.tr(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
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
                        const fw.SizedBox(height: 24),

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
                  ),
                ),
              )),
      ),
    );
  }
}
