import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';

/// Create Category Screen - Form to create new category
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  CreateModelCubit? createModelCubit;

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
            title: const Text('خطأ'),
            content: Text('فشل اختيار الصورة: $e'),
            actions: [
              PrimaryButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      }
    }
  }

  bool _validateFields(CategoryCubit cubit) {
    bool isValid = true;

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      cubit.setNameError('Category name is required');
      isValid = false;
    } else {
      cubit.clearNameError();
    }

    return isValid;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryCubit>();

    return Scaffold(
      child: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    variance: ButtonVariance.ghost,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Create Category',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Name Field
                        BlocBuilder<CategoryCubit, CategoryState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Category Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _nameController,
                                  placeholder: const Text(
                                    'Enter category name',
                                  ),
                                  onChanged: (value) {
                                    cubit.createCategoryParams.name = value;
                                    cubit.clearNameError();
                                  },
                                ),
                                if (cubit.nameError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
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
                        const SizedBox(height: 16),

                        // Description Field
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          placeholder: const Text(
                            'Enter description (optional)',
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            cubit.createCategoryParams.description = value;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Category Image Upload
                        BlocBuilder<CategoryCubit, CategoryState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'صورة التصنيف (اختياري)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (cubit.selectedImageFile != null)
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          cubit.selectedImageFile!,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            cubit.clearImageFile();
                                          },
                                          variance: ButtonVariance.destructive,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  OutlineButton(
                                    onPressed: cubit.isUploadingImage
                                        ? null
                                        : () => _pickImage(cubit),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('اختر صورة'),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Size Type Selection
                        BlocBuilder<CategoryCubit, CategoryState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Size Type',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _SizeTypeChip(
                                      label: 'None',
                                      value: 1,
                                      selectedValue: cubit.selectedSizeType,
                                      onSelected: (value) =>
                                          cubit.selectSizeType(value),
                                    ),
                                    _SizeTypeChip(
                                      label: 'Clothing',
                                      value: 2,
                                      selectedValue: cubit.selectedSizeType,
                                      onSelected: (value) =>
                                          cubit.selectSizeType(value),
                                    ),
                                    _SizeTypeChip(
                                      label: 'Shoes',
                                      value: 3,
                                      selectedValue: cubit.selectedSizeType,
                                      onSelected: (value) =>
                                          cubit.selectSizeType(value),
                                    ),
                                    _SizeTypeChip(
                                      label: 'One Size',
                                      value: 4,
                                      selectedValue: cubit.selectedSizeType,
                                      onSelected: (value) =>
                                          cubit.selectSizeType(value),
                                    ),
                                    _SizeTypeChip(
                                      label: 'Kids Age',
                                      value: 5,
                                      selectedValue: cubit.selectedSizeType,
                                      onSelected: (value) =>
                                          cubit.selectSizeType(value),
                                    ),
                                    _SizeTypeChip(
                                      label: 'Custom',
                                      value: 6,
                                      selectedValue: cubit.selectedSizeType,
                                      onSelected: (value) =>
                                          cubit.selectSizeType(value),
                                    ),
                                  ],
                                ),
                                if (cubit.sizeTypeError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.sizeTypeError!,
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
                        const SizedBox(height: 16),

                        // Active Switch
                        BlocBuilder<CategoryCubit, CategoryState>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Active',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Switch(
                                  value: cubit.createCategoryParams.isActive,
                                  onChanged: (value) {
                                    cubit.toggleIsActive(value);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 32),

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
                            return cubit.createCategoryWithImage();
                          },
                          onSuccess: (categoryModel) {
                            // Clear form
                            cubit.createCategoryParams.name = '';
                            cubit.createCategoryParams.description = '';
                            cubit.createCategoryParams.sizeType = 1;
                            cubit.createCategoryParams.isActive = true;
                            cubit.selectedSizeType = 1;
                            cubit.clearImageFile();
                            cubit.clearAllErrors();

                            // Show success dialog
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Success'),
                                content: const Text(
                                  'Category created successfully!',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      Navigator.pop(context); // Go back to list
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
                                  'Failed to create category: $error',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: PrimaryButton(
                            child: const Text('Create Category'),
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

/// Size Type Chip Widget for selection
class _SizeTypeChip extends StatelessWidget {
  final String label;
  final int value;
  final int? selectedValue;
  final Function(int) onSelected;

  const _SizeTypeChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? theme.colorScheme.primary : null,
          ),
        ),
      ),
    );
  }
}
