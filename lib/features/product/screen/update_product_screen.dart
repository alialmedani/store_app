import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:store/features/category/data/model/category_model.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../category/cubit/category_cubit.dart';
import '../cubit/product_cubit.dart';
import '../data/model/product_model.dart';

/// Update Product Screen - Form to update existing product
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class UpdateProductScreen extends StatefulWidget {
  final ProductModel product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProductCubit>();

    // Initialize params with existing product data
    cubit.updateProductParams.productId = widget.product.id ?? '';
    cubit.updateProductParams.name = widget.product.name ?? '';
    cubit.updateProductParams.description = widget.product.description ?? '';
    cubit.updateProductParams.price = widget.product.price ?? 0.0;
    cubit.updateProductParams.isActive = widget.product.isActive ?? true;
    cubit.updateProductParams.targetAudience = widget.product.targetAudience?.id ?? 0;
    cubit.updateProductParams.categoryId = widget.product.category?.id ?? '';

    // Initialize UI state
    cubit.selectedTargetAudience = widget.product.targetAudience?.id ?? 0;
    cubit.selectedCategoryId = widget.product.category?.id;

    // Initialize text controllers
    _nameController.text = widget.product.name ?? '';
    _descriptionController.text = widget.product.description ?? '';
    _priceController.text = widget.product.price?.toString() ?? '';
    _categoryIdController.text = widget.product.category?.name ?? '';
  }

  bool _validateFields(ProductCubit cubit) {
    bool isValid = true;

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      cubit.setNameError('Product name is required');
      isValid = false;
    } else {
      cubit.clearNameError();
    }

    // Validate price
    final priceText = _priceController.text.trim();
    if (priceText.isEmpty) {
      cubit.setPriceError('Price is required');
      isValid = false;
    } else {
      final price = double.tryParse(priceText);
      if (price == null) {
        cubit.setPriceError('Please enter a valid number');
        isValid = false;
      } else if (price <= 0) {
        cubit.setPriceError('Price must be greater than 0');
        isValid = false;
      } else {
        cubit.clearPriceError();
      }
    }

    // Validate category
    if (_categoryIdController.text.trim().isEmpty) {
      cubit.setCategoryError('Category is required');
      isValid = false;
    } else {
      cubit.clearCategoryError();
    }

    return isValid;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductCubit>();
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
                      'Update Product',
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
              child: SingleChildScrollView(
                padding: const fw.EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const fw.EdgeInsets.all(24),
                    child: fw.Column(
                      crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                      children: [
                        // Name Field
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Product Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const fw.SizedBox(height: 8),
                                TextField(
                                  controller: _nameController,
                                  placeholder: const Text('Enter product name'),
                                  onChanged: (value) {
                                    cubit.updateProductParams.name = value;
                                    cubit.clearNameError();
                                  },
                                ),
                                if (cubit.nameError != null)
                                  Padding(
                                    padding: const fw.EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.nameError!,
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

                        // Description Field
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const fw.SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          placeholder: const Text(
                            'Enter description (optional)',
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            cubit.updateProductParams.description = value;
                          },
                        ),
                        const fw.SizedBox(height: 16),

                        // Price Field
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const fw.SizedBox(height: 8),
                                TextField(
                                  controller: _priceController,
                                  placeholder: const Text('Enter price'),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  onChanged: (value) {
                                    final price = double.tryParse(value);
                                    if (price != null) {
                                      cubit.updateProductParams.price = price;
                                    }
                                    cubit.clearPriceError();
                                  },
                                ),
                                if (cubit.priceError != null)
                                  Padding(
                                    padding: const fw.EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.priceError!,
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

                        // Category Selection
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                fw.Row(
                                  children: [
                                    const fw.Expanded(
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    fw.GestureDetector(
                                      onTap: () {
                                        _showCategorySelector(context, cubit);
                                      },
                                      child: Text(
                                        'Change',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const fw.SizedBox(height: 8),
                                TextField(
                                  controller: _categoryIdController,
                                  placeholder: const Text('Select category'),
                                  enabled: false,
                                ),
                                if (cubit.categoryError != null)
                                  Padding(
                                    padding: const fw.EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.categoryError!,
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

                        // Target Audience Selection
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Target Audience',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const fw.SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _TargetAudienceChip(
                                      label: 'All',
                                      value: 0,
                                      selectedValue:
                                          cubit.selectedTargetAudience,
                                      onSelected: (value) {
                                        cubit.selectTargetAudience(value);
                                        cubit.updateProductParams.targetAudience = value;
                                      },
                                    ),
                                    _TargetAudienceChip(
                                      label: 'Men',
                                      value: 1,
                                      selectedValue:
                                          cubit.selectedTargetAudience,
                                      onSelected: (value) {
                                        cubit.selectTargetAudience(value);
                                        cubit.updateProductParams.targetAudience = value;
                                      },
                                    ),
                                    _TargetAudienceChip(
                                      label: 'Women',
                                      value: 2,
                                      selectedValue:
                                          cubit.selectedTargetAudience,
                                      onSelected: (value) {
                                        cubit.selectTargetAudience(value);
                                        cubit.updateProductParams.targetAudience = value;
                                      },
                                    ),
                                    _TargetAudienceChip(
                                      label: 'Kids',
                                      value: 3,
                                      selectedValue:
                                          cubit.selectedTargetAudience,
                                      onSelected: (value) {
                                        cubit.selectTargetAudience(value);
                                        cubit.updateProductParams.targetAudience = value;
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        const fw.SizedBox(height: 16),

                        // Active Switch
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return fw.Row(
                              mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Active',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Switch(
                                  value: cubit.updateProductParams.isActive,
                                  onChanged: (value) {
                                    cubit.updateProductParams.isActive = value;
                                    cubit.toggleIsActive(value);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const fw.SizedBox(height: 32),

                        // Submit Button
                        CreateModel<ProductModel>(
                          withValidation: true,
                          onTap: () {
                            return _validateFields(cubit);
                          },
                          useCaseCallBack: (data) {
                            return cubit.updateProduct();
                          },
                          onSuccess: (productModel) {
                            // Show success dialog
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Success'),
                                content: const Text(
                                  'Product updated successfully!',
                                ),
                                actions: [
                                  PrimaryButton(
                                    onPressed: () {
                                      fw.Navigator.pop(ctx);
                                      fw.Navigator.pop(context, true); // Return true to indicate success
                                    },
                                    child: const Text('OK'),
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
                                content: Text(
                                  'Failed to update product: $error',
                                ),
                                actions: [
                                  PrimaryButton(
                                    onPressed: () => fw.Navigator.pop(ctx),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: PrimaryButton(
                            child: const Text('Update Product'),
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

  void _showCategorySelector(BuildContext context, ProductCubit cubit) {
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider(
        create: (context) => CategoryCubit(),
        child: AlertDialog(
          title: const Text('Select Category'),
          content: fw.SizedBox(
            width: double.maxFinite,
            height: 400,
            child: PaginationList<CategoryModel>(
              withPagination: true,
              withRefresh: false,
              repositoryCallBack: (data) {
                return context.read<CategoryCubit>().fetchCategoryList(data);
              },
              listBuilder: (list) {
                return fw.ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final category = list[index];
                    return fw.GestureDetector(
                      onTap: () {
                        if (category.id != null && category.name != null) {
                          cubit.selectCategory(category.id!);
                          cubit.updateProductParams.categoryId = category.id!;
                          _categoryIdController.text = category.name!;
                        }
                        fw.Navigator.pop(ctx);
                      },
                      child: Card(
                        child: Padding(
                          padding: const fw.EdgeInsets.all(12),
                          child: Text(
                            category.name ?? 'N/A',
                            style: const TextStyle(fontSize: 14),
                          ),
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
              onPressed: () => fw.Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Target Audience Chip Widget for selection
class _TargetAudienceChip extends StatelessWidget {
  final String label;
  final int value;
  final int? selectedValue;
  final Function(int) onSelected;

  const _TargetAudienceChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    if (isSelected) {
      return PrimaryButton(
        onPressed: () => onSelected(value),
        child: Text(label),
      );
    }

    return OutlineButton(
      onPressed: () => onSelected(value),
      child: Text(label),
    );
  }
}
