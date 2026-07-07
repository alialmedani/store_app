import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';

/// Edit Category Screen - Form to edit existing category
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class EditCategoryScreen extends fw.StatefulWidget {
  final String categoryId;

  const EditCategoryScreen({super.key, required this.categoryId});

  @override
  fw.State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends fw.State<EditCategoryScreen> {
  final _nameController = fw.TextEditingController();
  final _descriptionController = fw.TextEditingController();
  final _imagePicker = ImagePicker();
  CreateModelCubit? createModelCubit;
  bool _isInitialized = false;

  Future<void> _pickImage(CategoryCubit cubit) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        cubit.selectImageFile(file);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to select image: $e'),
            actions: [
              PrimaryButton(
                onPressed: () => fw.Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  bool _validateFields(CategoryCubit cubit) {
    bool isValid = true;

    if (_nameController.text.trim().isEmpty) {
      cubit.setNameError('Category name is required');
      isValid = false;
    } else {
      cubit.clearNameError();
    }

    return isValid;
  }

  void _initializeFields(CategoryModel category, CategoryCubit cubit) {
    if (_isInitialized) return;

    _nameController.text = category.name ?? '';
    _descriptionController.text = category.description ?? '';

    cubit.updateCategoryParams.id = category.id;
    cubit.updateCategoryParams.name = category.name ?? '';
    cubit.updateCategoryParams.description = category.description ?? '';
    cubit.updateCategoryParams.sizeType = category.sizeTypeId ?? 1;
    cubit.updateCategoryParams.isActive = category.isActive ?? true;
    cubit.selectedSizeType = category.sizeTypeId ?? 1;

    _isInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<CategoryCubit>();

    return Scaffold(
      child: SafeArea(
        child: GetModel<CategoryModel>(
          useCaseCallBack: () => cubit.getCategoryDetails(widget.categoryId),
          modelBuilder: (category) {
            _initializeFields(category, cubit);
            final imageUrl = ImageHelper.getCategoryImageUrl(category.id ?? '');

            return fw.Column(
              children: [
                // App Bar
                fw.Container(
                  padding: const fw.EdgeInsets.fromLTRB(16, 16, 20, 20),
                  decoration: fw.BoxDecoration(
                    color: theme.colorScheme.background,
                    border: fw.Border(
                      bottom: fw.BorderSide(
                        color: theme.colorScheme.border.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: fw.Row(
                    children: [
                      fw.Container(
                        decoration: fw.BoxDecoration(
                          color: theme.colorScheme.muted.withOpacity(0.3),
                          borderRadius: fw.BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const fw.Icon(Icons.arrow_back, size: 20),
                          onPressed: () => fw.Navigator.pop(context),
                          variance: ButtonVariance.ghost,
                        ),
                      ),
                      const fw.SizedBox(width: 12),
                      const fw.Expanded(
                        child: Text(
                          'Edit Category',
                          style: fw.TextStyle(
                            fontSize: 24,
                            fontWeight: fw.FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Content
                fw.Expanded(
                  child: fw.SingleChildScrollView(
                    padding: const fw.EdgeInsets.all(20),
                    child: Card(
                      child: fw.Padding(
                        padding: const fw.EdgeInsets.all(24),
                        child: fw.Column(
                          crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                          children: [
                            // Name Field
                            BlocBuilder<CategoryCubit, CategoryState>(
                              builder: (context, state) {
                                return fw.Column(
                                  crossAxisAlignment:
                                      fw.CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Category Name',
                                      style: fw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: fw.FontWeight.w600,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 8),
                                    TextField(
                                      controller: _nameController,
                                      placeholder: const Text(
                                        'Enter category name',
                                      ),
                                      onChanged: (value) {
                                        cubit.updateCategoryParams.name = value;
                                        cubit.clearNameError();
                                      },
                                    ),
                                    if (cubit.nameError != null)
                                      fw.Padding(
                                        padding: const fw.EdgeInsets.only(
                                          top: 4,
                                        ),
                                        child: Text(
                                          cubit.nameError!,
                                          style: const fw.TextStyle(
                                            color: fw.Color(0xFFEF4444),
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
                              style: fw.TextStyle(
                                fontSize: 14,
                                fontWeight: fw.FontWeight.w600,
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
                                cubit.updateCategoryParams.description = value;
                              },
                            ),
                            const fw.SizedBox(height: 16),

                            // Category Image
                            BlocBuilder<CategoryCubit, CategoryState>(
                              builder: (context, state) {
                                return fw.Column(
                                  crossAxisAlignment:
                                      fw.CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Category Image (Optional)',
                                      style: fw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: fw.FontWeight.w600,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 8),
                                    if (cubit.selectedImageFile != null)
                                      fw.Stack(
                                        children: [
                                          fw.ClipRRect(
                                            borderRadius:
                                                fw.BorderRadius.circular(12),
                                            child: fw.Image.file(
                                              cubit.selectedImageFile!,
                                              height: 200,
                                              width: double.infinity,
                                              fit: fw.BoxFit.cover,
                                            ),
                                          ),
                                          fw.Positioned(
                                            top: 8,
                                            right: 8,
                                            child: fw.Container(
                                              decoration: fw.BoxDecoration(
                                                color: theme
                                                    .colorScheme
                                                    .destructive,
                                                borderRadius:
                                                    fw.BorderRadius.circular(8),
                                              ),
                                              child: IconButton(
                                                icon: const fw.Icon(
                                                  Icons.close,
                                                  size: 18,
                                                ),
                                                onPressed: () =>
                                                    cubit.clearImageFile(),
                                                variance: ButtonVariance.ghost,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else if (imageUrl.isNotEmpty)
                                      fw.Stack(
                                        children: [
                                          fw.Container(
                                            height: 200,
                                            width: double.infinity,
                                            decoration: fw.BoxDecoration(
                                              borderRadius:
                                                  fw.BorderRadius.circular(12),
                                              border: fw.Border.all(
                                                color: theme.colorScheme.border
                                                    .withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: fw.ClipRRect(
                                              borderRadius:
                                                  fw.BorderRadius.circular(12),
                                              child: AuthenticatedImage(
                                                imageUrl: imageUrl,
                                                width: double.infinity,
                                                height: 200,
                                                fit: fw.BoxFit.cover,
                                                errorWidget: fw.Container(
                                                  color: theme.colorScheme.muted
                                                      .withOpacity(0.3),
                                                  child: fw.Icon(
                                                    Icons.category_outlined,
                                                    size: 64,
                                                    color: theme
                                                        .colorScheme
                                                        .mutedForeground,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          fw.Positioned(
                                            bottom: 12,
                                            right: 12,
                                            child: OutlineButton(
                                              onPressed: () =>
                                                  _pickImage(cubit),
                                              child: const fw.Row(
                                                mainAxisSize:
                                                    fw.MainAxisSize.min,
                                                children: [
                                                  fw.Icon(Icons.edit, size: 16),
                                                  fw.SizedBox(width: 6),
                                                  Text('Change Image'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      OutlineButton(
                                        onPressed: () => _pickImage(cubit),
                                        child: fw.Row(
                                          mainAxisAlignment:
                                              fw.MainAxisAlignment.center,
                                          children: [
                                            fw.Icon(
                                              Icons.image,
                                              size: 20,
                                              color: theme.colorScheme.primary,
                                            ),
                                            const fw.SizedBox(width: 8),
                                            const Text('Select Image'),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const fw.SizedBox(height: 16),

                            // Size Type Selection
                            BlocBuilder<CategoryCubit, CategoryState>(
                              builder: (context, state) {
                                return fw.Column(
                                  crossAxisAlignment:
                                      fw.CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Size Type',
                                      style: fw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: fw.FontWeight.w600,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 8),
                                    fw.Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _SizeTypeChip(
                                          label: 'None',
                                          value: 1,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                    .updateCategoryParams
                                                    .sizeType =
                                                value;
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'Clothing',
                                          value: 2,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                    .updateCategoryParams
                                                    .sizeType =
                                                value;
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'Shoes',
                                          value: 3,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                    .updateCategoryParams
                                                    .sizeType =
                                                value;
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'One Size',
                                          value: 4,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                    .updateCategoryParams
                                                    .sizeType =
                                                value;
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'Kids Age',
                                          value: 5,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                    .updateCategoryParams
                                                    .sizeType =
                                                value;
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'Custom',
                                          value: 6,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                    .updateCategoryParams
                                                    .sizeType =
                                                value;
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
                            BlocBuilder<CategoryCubit, CategoryState>(
                              builder: (context, state) {
                                return fw.Row(
                                  mainAxisAlignment:
                                      fw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Active',
                                      style: fw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: fw.FontWeight.w600,
                                      ),
                                    ),
                                    Switch(
                                      value:
                                          cubit.updateCategoryParams.isActive,
                                      onChanged: (value) {
                                        cubit.updateCategoryParams.isActive =
                                            value;
                                        cubit.toggleIsActive(value);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            const fw.SizedBox(height: 32),

                            // Submit Button
                            CreateModel<CategoryModel>(
                              withValidation: true,
                              onCubitCreated: (createCubit) {
                                createModelCubit = createCubit;
                              },
                              onTap: () {
                                return _validateFields(cubit);
                              },
                              useCaseCallBack: (data) {
                                return cubit.updateCategory();
                              },
                              onSuccess: (categoryModel) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text(
                                      'Category updated successfully!',
                                    ),
                                    actions: [
                                      PrimaryButton(
                                        onPressed: () {
                                          fw.Navigator.pop(ctx);
                                          fw.Navigator.pop(context); // Go back
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
                                      'Failed to update category: $error',
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
                                child: const Text(
                                  'Update Category',
                                  style: fw.TextStyle(
                                    fontSize: 15,
                                    fontWeight: fw.FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Size Type Chip Widget
class _SizeTypeChip extends fw.StatelessWidget {
  final String label;
  final int value;
  final int? selectedValue;
  final fw.ValueChanged<int> onSelected;

  const _SizeTypeChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final isSelected = selectedValue == value;

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
