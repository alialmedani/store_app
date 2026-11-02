import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/features/category/data/model/category_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../category/cubit/category_cubit.dart';
import '../cubit/product_cubit.dart';
import '../data/model/product_model.dart';
import 'package:easy_localization/easy_localization.dart';

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

  /// 🖼️ NEW: Pick image only - upload happens after product creation
  Future<void> _pickImage(ProductCubit cubit) async {
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
            title: Text('error_2'.tr()),
            content: Text('failed_to_select_image'.tr(args: ['${e}'])),
            actions: [
              PrimaryButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('ok'.tr()),
              ),
            ],
          ),
        );
      }
    }
  }

  /// ✅ NEW: Simplified validation - no image upload check
  bool _validateFields(ProductCubit cubit) {
    bool isValid = true;

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      cubit.setNameError('product_name_is_required'.tr());
      isValid = false;
    } else {
      cubit.clearNameError();
    }

    // Validate price
    final priceText = _priceController.text.trim();
    if (priceText.isEmpty) {
      cubit.setPriceError('price_is_required'.tr());
      isValid = false;
    } else {
      final price = double.tryParse(priceText);
      if (price == null) {
        cubit.setPriceError('please_enter_a_valid_number'.tr());
        isValid = false;
      } else if (price <= 0) {
        cubit.setPriceError('price_must_be_greater_than_0'.tr());
        isValid = false;
      } else {
        cubit.clearPriceError();
      }
    }

    // Validate category
    if (_categoryIdController.text.trim().isEmpty) {
      cubit.setCategoryError('category_is_required'.tr());
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
        bottom: false, // Let StickyBottomAction handle bottom safe area
        child: fw.Column(children: [fw.Expanded(child: ScrollAwayHeader(header: fw.Column(children: [
            AppHeader(
              title: 'create_product'.tr(),
              onBack: () => fw.Navigator.pop(context),
            ),
            const fw.SizedBox(height: AppDesignTokens.smallGap)]), body: fw.SingleChildScrollView(
                padding: const fw.EdgeInsets.fromLTRB(
                  AppDesignTokens.screenPaddingHorizontal,
                  0,
                  AppDesignTokens.screenPaddingHorizontal,
                  120, // Extra bottom padding for sticky button + safe area
                ),
                child: AppCard(
                  child: fw.Column(
                    crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                    children: [
                      // Name Field
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          return fw.Column(
                            crossAxisAlignment: fw.CrossAxisAlignment.start,
                            children: [
                              fw.Text(
                                'product_name'.tr(),
                                style: fw.TextStyle(
                                  fontSize: AppDesignTokens.bodyFontSize,
                                  fontWeight: AppDesignTokens.semiBold,
                                  color: AppDesignTokens.titleTextColor,
                                ),
                              ),
                              const fw.SizedBox(
                                height: AppDesignTokens.smallGap,
                              ),
                              TextField(
                                controller: _nameController,
                                placeholder: Text('enter_product_name'.tr()),
                                onChanged: (value) {
                                  cubit.createProductParams.name = value;
                                  cubit.clearNameError();
                                },
                              ),
                              if (cubit.nameError != null)
                                fw.Padding(
                                  padding: const fw.EdgeInsets.only(
                                    top: AppDesignTokens.tinyGap,
                                  ),
                                  child: fw.Text(
                                    cubit.nameError!,
                                    style: fw.TextStyle(
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

                      // Description Field
                      fw.Text(
                        'description'.tr(),
                        style: fw.TextStyle(
                          fontSize: AppDesignTokens.bodyFontSize,
                          fontWeight: AppDesignTokens.semiBold,
                          color: AppDesignTokens.titleTextColor,
                        ),
                      ),
                      const fw.SizedBox(height: AppDesignTokens.smallGap),
                      TextField(
                        controller: _descriptionController,
                        placeholder: Text('enter_description_optional'.tr()),
                        maxLines: 3,
                        onChanged: (value) {
                          cubit.createProductParams.description = value;
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.itemGap),

                      // Price Field
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          return fw.Column(
                            crossAxisAlignment: fw.CrossAxisAlignment.start,
                            children: [
                              fw.Text(
                                'price'.tr(),
                                style: fw.TextStyle(
                                  fontSize: AppDesignTokens.bodyFontSize,
                                  fontWeight: AppDesignTokens.semiBold,
                                  color: AppDesignTokens.titleTextColor,
                                ),
                              ),
                              const fw.SizedBox(
                                height: AppDesignTokens.smallGap,
                              ),
                              TextField(
                                controller: _priceController,
                                placeholder: Text('enter_price'.tr()),
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
                                fw.Padding(
                                  padding: const fw.EdgeInsets.only(
                                    top: AppDesignTokens.tinyGap,
                                  ),
                                  child: fw.Text(
                                    cubit.priceError!,
                                    style: fw.TextStyle(
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

                      // Category Selection
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          return AppSelectorField(
                            label: 'category'.tr(),
                            value: _categoryIdController.text.isNotEmpty
                                ? _categoryIdController.text
                                : null,
                            placeholder: 'select_category_2'.tr(),
                            onTap: () {
                              _showCategorySelector(context, cubit);
                            },
                            actionText: 'select'.tr(),
                            errorText: cubit.categoryError,
                            showRequired: true,
                          );
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.itemGap),

                      // Product Image Upload
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          return fw.Column(
                            crossAxisAlignment: fw.CrossAxisAlignment.start,
                            children: [
                              fw.Text(
                                'product_image_optional'.tr(),
                                style: fw.TextStyle(
                                  fontSize: AppDesignTokens.bodyFontSize,
                                  fontWeight: AppDesignTokens.semiBold,
                                  color: AppDesignTokens.titleTextColor,
                                ),
                              ),
                              const fw.SizedBox(
                                height: AppDesignTokens.smallGap,
                              ),
                              if (cubit.selectedImageFile != null)
                                fw.Stack(
                                  children: [
                                    fw.ClipRRect(
                                      borderRadius: fw.BorderRadius.circular(
                                        AppDesignTokens.inputRadius,
                                      ),
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
                                      child: IconButton(
                                        icon: const fw.Icon(Icons.close),
                                        onPressed: () {
                                          cubit.clearImageFile();
                                        },
                                        variance: ButtonVariance.destructive,
                                      ),
                                    ),
                                    if (cubit.isUploadingImage)
                                      fw.Positioned.fill(
                                        child: fw.Container(
                                          color: fw.Color(0x80000000),
                                          child: const fw.Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              else
                                OutlineButton(
                                  onPressed: cubit.isUploadingImage
                                      ? null
                                      : () => _pickImage(cubit),
                                  child: fw.Row(
                                    mainAxisAlignment:
                                        fw.MainAxisAlignment.center,
                                    children: [
                                      fw.Icon(
                                        Icons.image,
                                        size: 20,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const fw.SizedBox(
                                        width: AppDesignTokens.smallGap,
                                      ),
                                      Text('choose_image'.tr()),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.itemGap),

                      // Target Audience Selection
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          return fw.Column(
                            crossAxisAlignment: fw.CrossAxisAlignment.start,
                            children: [
                              fw.Text(
                                'target_audience'.tr(),
                                style: fw.TextStyle(
                                  fontSize: AppDesignTokens.bodyFontSize,
                                  fontWeight: AppDesignTokens.semiBold,
                                  color: AppDesignTokens.titleTextColor,
                                ),
                              ),
                              const fw.SizedBox(
                                height: AppDesignTokens.smallGap,
                              ),
                              fw.Wrap(
                                spacing: AppDesignTokens.smallGap,
                                runSpacing: AppDesignTokens.smallGap,
                                children: [
                                  _TargetAudienceChip(
                                    label: 'all'.tr(),
                                    value: 0,
                                    selectedValue: cubit.selectedTargetAudience,
                                    onSelected: (value) =>
                                        cubit.selectTargetAudience(value),
                                  ),
                                  _TargetAudienceChip(
                                    label: 'men'.tr(),
                                    value: 1,
                                    selectedValue: cubit.selectedTargetAudience,
                                    onSelected: (value) =>
                                        cubit.selectTargetAudience(value),
                                  ),
                                  _TargetAudienceChip(
                                    label: 'women'.tr(),
                                    value: 2,
                                    selectedValue: cubit.selectedTargetAudience,
                                    onSelected: (value) =>
                                        cubit.selectTargetAudience(value),
                                  ),
                                  _TargetAudienceChip(
                                    label: 'kids'.tr(),
                                    value: 3,
                                    selectedValue: cubit.selectedTargetAudience,
                                    onSelected: (value) =>
                                        cubit.selectTargetAudience(value),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.itemGap),

                      // Active Switch
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          return fw.Row(
                            mainAxisAlignment:
                                fw.MainAxisAlignment.spaceBetween,
                            children: [
                              fw.Text(
                                'active'.tr(),
                                style: fw.TextStyle(
                                  fontSize: AppDesignTokens.bodyFontSize,
                                  fontWeight: AppDesignTokens.semiBold,
                                  color: AppDesignTokens.titleTextColor,
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
                    ],
                  ),
                ),
              ))),
            StickyBottomAction(
              child: CreateModel<ProductModel>(
                withValidation: true,
                onCubitCreated: (createCubit) {
                  createModelCubit = createCubit;
                },
                onTap: () {
                  return _validateFields(cubit);
                },
                useCaseCallBack: (data) {
                  return cubit.createProductWithImage();
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
                      title: Text('success'.tr()),
                      content: Text('product_created_successfully'.tr()),
                      actions: [
                        PrimaryButton(
                          onPressed: () {
                            fw.Navigator.pop(ctx);
                            fw.Navigator.pop(context);
                          },
                          child: Text('ok'.tr()),
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
                      content: Text('failed_to_create_product'.tr(args: ['${error}'])),
                      actions: [
                        PrimaryButton(
                          onPressed: () => fw.Navigator.pop(ctx),
                          child: Text('ok'.tr()),
                        ),
                      ],
                    ),
                  );
                },
                child: fw.SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    child: Text(
                      'create_product'.tr(),
                      style: fw.TextStyle(
                        fontSize: 15,
                        fontWeight: AppDesignTokens.semiBold,
                      ),
                    ),
                  ),
                ),
              ),
            )]),
      ),
    );
  }

  void _showCategorySelector(BuildContext context, ProductCubit cubit) {
    AppBottomSelector.show<CategoryModel>(
      context: context,
      title: 'select_category'.tr(),
      content: BlocProvider(
        create: (context) => CategoryCubit(),
        child: PaginationList<CategoryModel>(
          withPagination: true,
          withRefresh: false,
          loadingWidget: fw.ListView.builder(
            padding: const fw.EdgeInsets.symmetric(
              vertical: AppDesignTokens.smallGap,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return const SelectorItemSkeleton(
                withLeading: false,
                withSubtitle: true,
              );
            },
          ),
          repositoryCallBack: (data) {
            return context.read<CategoryCubit>().fetchCategoryList(data);
          },
          listBuilder: (list) {
            return fw.ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final category = list[index];
                final isSelected = category.id == cubit.selectedCategoryId;

                return AppBottomSelector.buildStandardItem<CategoryModel>(
                  context: context,
                  item: category,
                  titleBuilder: (cat) => cat.name ?? 'N/A',
                  subtitleBuilder: (cat) => cat.description,
                  isSelected: isSelected,
                  onTap: () {
                    if (category.id != null && category.name != null) {
                      cubit.selectCategory(category.id!);
                      _categoryIdController.text = category.name!;
                    }
                    fw.Navigator.pop(context);
                  },
                );
              },
            );
          },
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
