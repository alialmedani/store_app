import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:store/features/category/data/model/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../category/cubit/category_cubit.dart';
import '../cubit/product_cubit.dart';
import '../data/model/product_model.dart';

/// Create Product Screen - Form to create new product
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryIdController = TextEditingController();
  CreateModelCubit? createModelCubit;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickAndUploadImage(ProductCubit cubit) async {
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

        // رفع الصورة تلقائياً
        final uploadResult = await cubit.uploadProductImage();

        if (uploadResult.hasErrorOnly && mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('خطأ'),
              content: Text(uploadResult.error ?? 'فشل رفع الصورة'),
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

  bool _validateFields(ProductCubit cubit) {
    bool isValid = true;

    // Check if image is still uploading
    if (cubit.isUploadingImage) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('انتظر'),
          content: const Text('جارٍ رفع الصورة... يرجى الانتظار'),
          actions: [
            PrimaryButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
      return false;
    }

    // Check if image was selected but upload failed
    if (cubit.selectedImageFile != null &&
        cubit.createProductParams.imageUrl.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('خطأ'),
          content: const Text('فشل رفع الصورة. يرجى اختيار الصورة مرة أخرى'),
          actions: [
            PrimaryButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
      return false;
    }

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
                      'Create Product',
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
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Product Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _nameController,
                                  placeholder: const Text('Enter product name'),
                                  onChanged: (value) {
                                    cubit.createProductParams.name = value;
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
                            cubit.createProductParams.description = value;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Price Field
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                                      cubit.createProductParams.price = price;
                                    }
                                    cubit.clearPriceError();
                                  },
                                ),
                                if (cubit.priceError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
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
                        const SizedBox(height: 16),

                        // Category Selection
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _showCategorySelector(context, cubit);
                                      },
                                      child: Text(
                                        'Select',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _categoryIdController,
                                  placeholder: const Text('Select category'),
                                  enabled: false,
                                ),
                                if (cubit.categoryError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
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
                        const SizedBox(height: 16),

                        // Product Image Upload
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'صورة المنتج (اختياري)',
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
                                      if (cubit.isUploadingImage)
                                        Positioned.fill(
                                          child: Container(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                else
                                  OutlineButton(
                                    onPressed: cubit.isUploadingImage
                                        ? null
                                        : () => _pickAndUploadImage(cubit),
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
                                        Text(
                                          cubit.isUploadingImage
                                              ? 'جاري الرفع...'
                                              : 'اختر صورة',
                                        ),
                                      ],
                                    ),
                                  ),
                                if (cubit
                                        .createProductParams
                                        .imageUrl
                                        .isNotEmpty &&
                                    !cubit.isUploadingImage)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '✓ تم رفع الصورة بنجاح',
                                      style: TextStyle(
                                        color: const Color(0xFF10B981),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Target Audience Selection
                        BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Target Audience',
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
                                    _TargetAudienceChip(
                                      label: 'All',
                                      value: 0,
                                      selectedValue:
                                          cubit.selectedTargetAudience,
                                      onSelected: (value) =>
                                          cubit.selectTargetAudience(value),
                                    ),
                                    _TargetAudienceChip(
                                      label: 'Men',
                                      value: 1,
                                      selectedValue:
                                          cubit.selectedTargetAudience,
                                      onSelected: (value) =>
                                          cubit.selectTargetAudience(value),
                                    ),
                                    _TargetAudienceChip(
                                      label: 'Women',
                                      value: 2,
                                      selectedValue:
                                          cubit.selectedTargetAudience,
                                      onSelected: (value) =>
                                          cubit.selectTargetAudience(value),
                                    ),
                                    _TargetAudienceChip(
                                      label: 'Kids',
                                      value: 3,
                                      selectedValue:
                                          cubit.selectedTargetAudience,
                                      onSelected: (value) =>
                                          cubit.selectTargetAudience(value),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Active Switch
                        BlocBuilder<ProductCubit, ProductState>(
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
                                  value: cubit.createProductParams.isActive,
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
                        CreateModel<ProductModel>(
                          withValidation: true,
                          onCubitCreated: (createCubit) {
                            createModelCubit = createCubit;
                          },
                          onTap: () {
                            return _validateFields(cubit);
                          },
                          useCaseCallBack: (data) {
                            return cubit.createProduct();
                          },
                          onSuccess: (productModel) {
                            // Clear form
                            cubit.createProductParams.name = '';
                            cubit.createProductParams.description = '';
                            cubit.createProductParams.price = 0.0;
                            cubit.createProductParams.isActive = true;
                            cubit.createProductParams.targetAudience = 0;
                            cubit.createProductParams.categoryId = '';
                            cubit.createProductParams.imageUrl = '';
                            cubit.selectedTargetAudience = 0;
                            cubit.selectedCategoryId = null;
                            cubit.clearAllErrors();

                            // Clear controllers
                            _nameController.clear();
                            _descriptionController.clear();
                            _priceController.clear();
                            _categoryIdController.clear();
                            cubit.clearImageFile();

                            // Show success dialog
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Success'),
                                content: const Text(
                                  'Product created successfully!',
                                ),
                                actions: [
                                  PrimaryButton(
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
                                  'Failed to create product: $error',
                                ),
                                actions: [
                                  PrimaryButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: PrimaryButton(
                            child: const Text('Create Product'),
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
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: PaginationList<CategoryModel>(
              withPagination: true,
              withRefresh: false,
              repositoryCallBack: (data) {
                return context.read<CategoryCubit>().fetchCategoryList(data);
              },
              listBuilder: (list) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final category = list[index];
                    return GestureDetector(
                      onTap: () {
                        if (category.id != null && category.name != null) {
                          cubit.selectCategory(category.id!);
                          _categoryIdController.text = category.name!;
                        }
                        Navigator.pop(ctx);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
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
              onPressed: () => Navigator.pop(ctx),
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
