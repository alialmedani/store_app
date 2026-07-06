import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/product_variant_cubit.dart';
import '../data/model/product_variant_model.dart';

/// Update Product Variant Screen - Form to update existing product variant
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class UpdateProductVariantScreen extends fw.StatefulWidget {
  final ProductVariantModel variant;

  const UpdateProductVariantScreen({
    super.key,
    required this.variant,
  });

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
    cubit.updateProductVariantParams.productVariantId =
        widget.variant.id ?? '';
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
        child: fw.Column(
          children: [
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
                  const fw.Expanded(
                    child: Text(
                      'Update Product Variant',
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
            fw.Expanded(
              child: fw.SingleChildScrollView(
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
                            const Text(
                              'Product',
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
                                color: theme.colorScheme.muted.withOpacity(0.3),
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
                                    const Text(
                                      'Color',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const fw.SizedBox(width: 8),
                                    Text(
                                      '(Optional)',
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
                                  placeholder: const Text(
                                    'Enter color (optional)',
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
                                      style: const TextStyle(
                                        color: Color(0xFFEF4444),
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
                                    const Text(
                                      'Size',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const fw.SizedBox(width: 8),
                                    Text(
                                      '(Optional)',
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
                                  placeholder: const Text(
                                    'Enter size (optional)',
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
                                      style: const TextStyle(
                                        color: Color(0xFFEF4444),
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
                                const fw.Expanded(
                                  child: Text(
                                    'Active',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: cubit
                                      .updateProductVariantParams.isActive,
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
                                title: const Text('Success'),
                                content: const Text(
                                  'Product variant updated successfully.',
                                ),
                                actions: [
                                  PrimaryButton(
                                    child: const Text('OK'),
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
                            child: const Text('Update Product Variant'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
