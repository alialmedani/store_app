import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../../core/constant/enum/enum.dart';
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
    cubit.updateCategoryParams.sizeType = category.sizeTypeId ?? 0;
    cubit.updateCategoryParams.isActive = category.isActive ?? true;
    cubit.selectedSizeType =
        SizeType.fromInt(category.sizeTypeId) ?? SizeType.none;

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
                // Modern App Bar
                fw.Container(
                  padding: const fw.EdgeInsets.fromLTRB(20, 20, 24, 24),
                  decoration: fw.BoxDecoration(
                    color: theme.colorScheme.background,
                    border: fw.Border(
                      bottom: fw.BorderSide(
                        color: theme.colorScheme.border.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                  ),
                  child: fw.Row(
                    children: [
                      fw.Container(
                        padding: const fw.EdgeInsets.all(2),
                        decoration: fw.BoxDecoration(
                          color: theme.colorScheme.muted.withValues(alpha: 0.5),
                          borderRadius: fw.BorderRadius.circular(14),
                          border: fw.Border.all(
                            color: theme.colorScheme.border.withValues(
                              alpha: 0.1,
                            ),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: const fw.Icon(Icons.arrow_back, size: 20),
                          onPressed: () => fw.Navigator.pop(context),
                          variance: ButtonVariance.ghost,
                        ),
                      ),
                      const fw.SizedBox(width: 16),
                      fw.Expanded(
                        child: fw.Column(
                          crossAxisAlignment: fw.CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Edit Category',
                              style: fw.TextStyle(
                                fontSize: 28,
                                fontWeight: fw.FontWeight.w700,
                                letterSpacing: -0.8,
                                height: 1.2,
                              ),
                            ),
                            const fw.SizedBox(height: 4),
                            Text(
                              'Update category details',
                              style: fw.TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.mutedForeground,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Content
                fw.Expanded(
                  child: fw.SingleChildScrollView(
                    padding: const fw.EdgeInsets.all(24),
                    child: Card(
                      child: fw.Padding(
                        padding: const fw.EdgeInsets.all(32),
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
                                    Row(
                                      children: [
                                        Text(
                                          'Category Name',
                                          style: fw.TextStyle(
                                            fontSize: 15,
                                            fontWeight: fw.FontWeight.w600,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const fw.SizedBox(width: 4),
                                        Text(
                                          '*',
                                          style: fw.TextStyle(
                                            fontSize: 15,
                                            fontWeight: fw.FontWeight.w600,
                                            color:
                                                theme.colorScheme.destructive,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const fw.SizedBox(height: 10),
                                    TextField(
                                      controller: _nameController,
                                      placeholder: const Text(
                                        'Enter a descriptive category name',
                                      ),
                                      onChanged: (value) {
                                        cubit.updateCategoryParams.name = value;
                                        cubit.clearNameError();
                                      },
                                    ),
                                    if (cubit.nameError != null)
                                      fw.Padding(
                                        padding: const fw.EdgeInsets.only(
                                          top: 6,
                                        ),
                                        child: Text(
                                          cubit.nameError!,
                                          style: fw.TextStyle(
                                            color:
                                                theme.colorScheme.destructive,
                                            fontSize: 13,
                                            fontWeight: fw.FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const fw.SizedBox(height: 24),

                            // Description Field
                            Text(
                              'Description',
                              style: fw.TextStyle(
                                fontSize: 15,
                                fontWeight: fw.FontWeight.w600,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const fw.SizedBox(height: 10),
                            TextField(
                              controller: _descriptionController,
                              placeholder: const Text(
                                'Add a brief description about this category',
                              ),
                              maxLines: 4,
                              onChanged: (value) {
                                cubit.updateCategoryParams.description = value;
                              },
                            ),
                            const fw.SizedBox(height: 24),

                            // Category Image
                            BlocBuilder<CategoryCubit, CategoryState>(
                              builder: (context, state) {
                                return fw.Column(
                                  crossAxisAlignment:
                                      fw.CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Category Image',
                                      style: fw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: fw.FontWeight.w600,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 4),
                                    Text(
                                      'Optional — Recommended size: 800x600',
                                      style: fw.TextStyle(
                                        fontSize: 13,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 12),
                                    if (cubit.selectedImageFile != null)
                                      fw.Container(
                                        decoration: fw.BoxDecoration(
                                          borderRadius:
                                              fw.BorderRadius.circular(16),
                                          border: fw.Border.all(
                                            color: theme.colorScheme.border
                                                .withValues(alpha: 0.2),
                                            width: 2,
                                          ),
                                        ),
                                        child: fw.Stack(
                                          children: [
                                            fw.ClipRRect(
                                              borderRadius:
                                                  fw.BorderRadius.circular(14),
                                              child: fw.Image.file(
                                                cubit.selectedImageFile!,
                                                height: 220,
                                                width: double.infinity,
                                                fit: fw.BoxFit.cover,
                                              ),
                                            ),
                                            fw.Positioned(
                                              top: 12,
                                              right: 12,
                                              child: fw.Container(
                                                decoration: fw.BoxDecoration(
                                                  color: theme
                                                      .colorScheme
                                                      .destructive
                                                      .withValues(alpha: 0.95),
                                                  borderRadius:
                                                      fw.BorderRadius.circular(
                                                        10,
                                                      ),
                                                  boxShadow: [
                                                    fw.BoxShadow(
                                                      color: fw.Color(
                                                        0x33000000,
                                                      ),
                                                      blurRadius: 8,
                                                      offset: const fw.Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: IconButton(
                                                  icon: const fw.Icon(
                                                    Icons.close,
                                                    size: 18,
                                                  ),
                                                  onPressed: () =>
                                                      cubit.clearImageFile(),
                                                  variance:
                                                      ButtonVariance.ghost,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else if (imageUrl.isNotEmpty)
                                      fw.Stack(
                                        children: [
                                          fw.Container(
                                            height: 220,
                                            width: double.infinity,
                                            decoration: fw.BoxDecoration(
                                              borderRadius:
                                                  fw.BorderRadius.circular(16),
                                              border: fw.Border.all(
                                                color: theme.colorScheme.border
                                                    .withValues(alpha: 0.2),
                                                width: 2,
                                              ),
                                            ),
                                            child: fw.ClipRRect(
                                              borderRadius:
                                                  fw.BorderRadius.circular(14),
                                              child: AuthenticatedImage(
                                                imageUrl: imageUrl,
                                                width: double.infinity,
                                                height: 220,
                                                fit: fw.BoxFit.cover,
                                                errorWidget: fw.Container(
                                                  color: theme.colorScheme.muted
                                                      .withValues(alpha: 0.3),
                                                  child: fw.Center(
                                                    child: fw.Icon(
                                                      Icons.category_outlined,
                                                      size: 72,
                                                      color: theme
                                                          .colorScheme
                                                          .mutedForeground
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          fw.Positioned(
                                            bottom: 16,
                                            right: 16,
                                            child: fw.Container(
                                              decoration: fw.BoxDecoration(
                                                borderRadius: fw
                                                    .BorderRadius.circular(12),
                                                boxShadow: [
                                                  fw.BoxShadow(
                                                    color: fw.Color(0x33000000),
                                                    blurRadius: 12,
                                                    offset: const fw.Offset(
                                                      0,
                                                      4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              child: SecondaryButton(
                                                onPressed: () =>
                                                    _pickImage(cubit),
                                                child: const fw.Row(
                                                  mainAxisSize:
                                                      fw.MainAxisSize.min,
                                                  children: [
                                                    fw.Icon(
                                                      Icons.edit,
                                                      size: 16,
                                                    ),
                                                    fw.SizedBox(width: 8),
                                                    Text('Change Image'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      fw.GestureDetector(
                                        onTap: () => _pickImage(cubit),
                                        child: fw.Container(
                                          height: 180,
                                          decoration: fw.BoxDecoration(
                                            color: theme.colorScheme.muted
                                                .withValues(alpha: 0.3),
                                            borderRadius:
                                                fw.BorderRadius.circular(16),
                                            border: fw.Border.all(
                                              color: theme.colorScheme.border
                                                  .withValues(alpha: 0.3),
                                              width: 2,
                                              style: fw.BorderStyle.solid,
                                            ),
                                          ),
                                          child: fw.Center(
                                            child: fw.Column(
                                              mainAxisAlignment:
                                                  fw.MainAxisAlignment.center,
                                              children: [
                                                fw.Icon(
                                                  Icons.cloud_upload_outlined,
                                                  size: 48,
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.7),
                                                ),
                                                const fw.SizedBox(height: 12),
                                                Text(
                                                  'Click to upload image',
                                                  style: fw.TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        fw.FontWeight.w600,
                                                    color: theme
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                                const fw.SizedBox(height: 4),
                                                Text(
                                                  'PNG, JPG up to 10MB',
                                                  style: fw.TextStyle(
                                                    fontSize: 13,
                                                    color: theme
                                                        .colorScheme
                                                        .mutedForeground
                                                        .withValues(alpha: 0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const fw.SizedBox(height: 24),

                            // Size Type Selection
                            BlocBuilder<CategoryCubit, CategoryState>(
                              builder: (context, state) {
                                return fw.Column(
                                  crossAxisAlignment:
                                      fw.CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Size Type',
                                      style: fw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: fw.FontWeight.w600,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 4),
                                    Text(
                                      'Choose the appropriate sizing system',
                                      style: fw.TextStyle(
                                        fontSize: 13,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ),
                                    const fw.SizedBox(height: 12),
                                    fw.Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        _SizeTypeChip(
                                          label: 'None',
                                          value: SizeType.none,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                .updateCategoryParams
                                                .sizeType = value
                                                .toInt();
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'Clothing',
                                          value: SizeType.clothing,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                .updateCategoryParams
                                                .sizeType = value
                                                .toInt();
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'Shoes',
                                          value: SizeType.shoes,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                .updateCategoryParams
                                                .sizeType = value
                                                .toInt();
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'One Size',
                                          value: SizeType.oneSize,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                .updateCategoryParams
                                                .sizeType = value
                                                .toInt();
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'Kids Age',
                                          value: SizeType.kidsAge,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                .updateCategoryParams
                                                .sizeType = value
                                                .toInt();
                                          },
                                        ),
                                        _SizeTypeChip(
                                          label: 'Custom',
                                          value: SizeType.custom,
                                          selectedValue: cubit.selectedSizeType,
                                          onSelected: (value) {
                                            cubit.selectSizeType(value);
                                            cubit
                                                .updateCategoryParams
                                                .sizeType = value
                                                .toInt();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            const fw.SizedBox(height: 24),

                            // Active Switch
                            BlocBuilder<CategoryCubit, CategoryState>(
                              builder: (context, state) {
                                return fw.Container(
                                  padding: const fw.EdgeInsets.all(20),
                                  decoration: fw.BoxDecoration(
                                    color: theme.colorScheme.muted.withValues(
                                      alpha: 0.3,
                                    ),
                                    borderRadius: fw.BorderRadius.circular(14),
                                    border: fw.Border.all(
                                      color: theme.colorScheme.border
                                          .withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: fw.Row(
                                    mainAxisAlignment:
                                        fw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      fw.Column(
                                        crossAxisAlignment:
                                            fw.CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Category Status',
                                            style: fw.TextStyle(
                                              fontSize: 15,
                                              fontWeight: fw.FontWeight.w600,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          const fw.SizedBox(height: 4),
                                          Text(
                                            cubit.updateCategoryParams.isActive
                                                ? 'Visible to customers'
                                                : 'Hidden from store',
                                            style: fw.TextStyle(
                                              fontSize: 13,
                                              color: theme
                                                  .colorScheme
                                                  .mutedForeground,
                                            ),
                                          ),
                                        ],
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
                                  ),
                                );
                              },
                            ),
                            const fw.SizedBox(height: 40),

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
                                          fw.Navigator.pop(context);
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
                              child: fw.SizedBox(
                                height: 52,
                                child: PrimaryButton(
                                  child: const Text(
                                    'Update Category',
                                    style: fw.TextStyle(
                                      fontSize: 16,
                                      fontWeight: fw.FontWeight.w600,
                                      letterSpacing: -0.3,
                                    ),
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

/// Modern Size Type Chip Widget
class _SizeTypeChip extends fw.StatelessWidget {
  final String label;
  final SizeType value;
  final SizeType? selectedValue;
  final fw.ValueChanged<SizeType> onSelected;

  const _SizeTypeChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selectedValue == value;

    if (isSelected) {
      return PrimaryButton(
        onPressed: () => onSelected(value),
        child: fw.Padding(
          padding: const fw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            label,
            style: const fw.TextStyle(
              fontSize: 14,
              fontWeight: fw.FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
        ),
      );
    }

    return OutlineButton(
      onPressed: () => onSelected(value),
      child: fw.Padding(
        padding: const fw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          label,
          style: fw.TextStyle(
            fontSize: 14,
            fontWeight: fw.FontWeight.w500,
            letterSpacing: -0.2,
            color: theme.colorScheme.foreground.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}
