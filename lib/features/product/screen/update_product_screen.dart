import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/features/category/data/model/category_model.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../category/cubit/category_cubit.dart';
import '../cubit/product_cubit.dart';
import '../../../core/ui/widgets/authenticated_image.dart';
import '../../../core/utils/image_helper.dart';
import '../data/model/product_model.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

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
    cubit.updateProductParams.targetAudience =
        widget.product.targetAudience?.id ?? 0;
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

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(ProductCubit cubit) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) cubit.selectImageFile(File(image.path));
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('error_2'.tr()),
          content: Text('failed_to_select_image'.tr(args: ['$e'])),
          actions: [
            PrimaryButton(
              onPressed: () => fw.Navigator.pop(ctx),
              child: Text('ok'.tr()),
            ),
          ],
        ),
      );
    }
  }

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
                      'update_product'.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )]), body: SingleChildScrollView(
                padding: const fw.EdgeInsets.all(
                  AppDesignTokens.screenPaddingHorizontal,
                ),
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                  children: [
                    // Media section: product image
                    AppCard(
                      elevated: true,
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                        children: [
                          _FormSectionHeader(title: 'media'.tr()),
                          const fw.SizedBox(height: AppDesignTokens.sectionGap),

                          // Product image (current one, or the newly picked file)
                          BlocBuilder<ProductCubit, ProductState>(
                            builder: (context, state) {
                              final picked = cubit.selectedImageFile;
                              return fw.GestureDetector(
                                onTap: cubit.isUploadingImage
                                    ? null
                                    : () => _pickImage(cubit),
                                child: fw.Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration:
                                      AppDesignTokens.glassDecoration(),
                                  child: fw.ClipRRect(
                                    borderRadius: fw.BorderRadius.circular(
                                      AppDesignTokens.cardRadius,
                                    ),
                                    child: fw.Stack(
                                      fit: fw.StackFit.expand,
                                      children: [
                                        if (picked != null)
                                          fw.Image.file(
                                            picked,
                                            fit: fw.BoxFit.cover,
                                          )
                                        else
                                          AuthenticatedImage(
                                            imageUrl:
                                                ImageHelper.getProductImageUrl(
                                                  widget.product.id ?? '',
                                                ),
                                            width: double.infinity,
                                            height: 200,
                                            fit: fw.BoxFit.cover,
                                            errorWidget: fw.Center(
                                              child: fw.Icon(
                                                Icons.inventory_2_outlined,
                                                size: 56,
                                                color: AppDesignTokens
                                                    .mutedTextColor,
                                              ),
                                            ),
                                          ),
                                        fw.Positioned(
                                          left: 12,
                                          bottom: 12,
                                          child: fw.Container(
                                            padding:
                                                const fw.EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                            decoration: fw.BoxDecoration(
                                              gradient: AppDesignTokens
                                                  .primaryGradient,
                                              borderRadius:
                                                  fw.BorderRadius.circular(
                                                    AppDesignTokens
                                                        .badgeRadius,
                                                  ),
                                            ),
                                            child: fw.Row(
                                              mainAxisSize:
                                                  fw.MainAxisSize.min,
                                              children: [
                                                const fw.Icon(
                                                  Icons.photo_camera_rounded,
                                                  size: 16,
                                                  color: fw.Color(0xFFFFFFFF),
                                                ),
                                                const fw.SizedBox(width: 6),
                                                Text(
                                                  'change_image'.tr(),
                                                  style: const fw.TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        fw.FontWeight.w700,
                                                    color: fw.Color(
                                                      0xFFFFFFFF,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (cubit.isUploadingImage)
                                          fw.Container(
                                            color: const fw.Color(
                                              0x80000000,
                                            ),
                                            child: const fw.Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.cardGap),

                    // Basics section: name, description, price
                    AppCard(
                      elevated: true,
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                        children: [
                          _FormSectionHeader(title: 'basics'.tr()),
                          const fw.SizedBox(height: AppDesignTokens.sectionGap),

                          // Name Field
                          BlocBuilder<ProductCubit, ProductState>(
                            builder: (context, state) {
                              return fw.Column(
                                crossAxisAlignment:
                                    fw.CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'product_name'.tr(),
                                    style: TextStyle(
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
                                    placeholder: Text(
                                      'enter_product_name'.tr(),
                                    ),
                                    onChanged: (value) {
                                      cubit.updateProductParams.name = value;
                                      cubit.clearNameError();
                                    },
                                  ),
                                  if (cubit.nameError != null)
                                    Padding(
                                      padding: const fw.EdgeInsets.only(
                                        top: AppDesignTokens.tinyGap,
                                      ),
                                      child: Text(
                                        cubit.nameError!,
                                        style: TextStyle(
                                          color: AppDesignTokens.dangerColor,
                                          fontSize:
                                              AppDesignTokens.captionFontSize,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),

                          // Description Field
                          Text(
                            'description'.tr(),
                            style: TextStyle(
                              fontSize: AppDesignTokens.bodyFontSize,
                              fontWeight: AppDesignTokens.semiBold,
                              color: AppDesignTokens.titleTextColor,
                            ),
                          ),
                          const fw.SizedBox(height: AppDesignTokens.smallGap),
                          TextField(
                            controller: _descriptionController,
                            placeholder: Text(
                              'enter_description_optional'.tr(),
                            ),
                            maxLines: 3,
                            onChanged: (value) {
                              cubit.updateProductParams.description = value;
                            },
                          ),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),

                          // Price Field
                          BlocBuilder<ProductCubit, ProductState>(
                            builder: (context, state) {
                              return fw.Column(
                                crossAxisAlignment:
                                    fw.CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'price'.tr(),
                                    style: TextStyle(
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
                                        cubit.updateProductParams.price =
                                            price;
                                      }
                                      cubit.clearPriceError();
                                    },
                                  ),
                                  if (cubit.priceError != null)
                                    Padding(
                                      padding: const fw.EdgeInsets.only(
                                        top: AppDesignTokens.tinyGap,
                                      ),
                                      child: Text(
                                        cubit.priceError!,
                                        style: TextStyle(
                                          color: AppDesignTokens.dangerColor,
                                          fontSize:
                                              AppDesignTokens.captionFontSize,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.cardGap),

                    // Classification section: category, target audience
                    AppCard(
                      elevated: true,
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                        children: [
                          _FormSectionHeader(title: 'classification'.tr()),
                          const fw.SizedBox(height: AppDesignTokens.sectionGap),

                          // Category Selection
                          BlocBuilder<ProductCubit, ProductState>(
                            builder: (context, state) {
                              return fw.Column(
                                crossAxisAlignment:
                                    fw.CrossAxisAlignment.start,
                                children: [
                                  AppSelectorField(
                                    label: 'category'.tr(),
                                    value:
                                        _categoryIdController.text.isNotEmpty
                                        ? _categoryIdController.text
                                        : null,
                                    placeholder: 'select_category_2'.tr(),
                                    onTap: () =>
                                        _showCategorySelector(context, cubit),
                                  ),
                                  if (cubit.categoryError != null)
                                    Padding(
                                      padding: const fw.EdgeInsets.only(
                                        top: AppDesignTokens.tinyGap,
                                      ),
                                      child: Text(
                                        cubit.categoryError!,
                                        style: TextStyle(
                                          color: AppDesignTokens.dangerColor,
                                          fontSize:
                                              AppDesignTokens.captionFontSize,
                                        ),
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
                                crossAxisAlignment:
                                    fw.CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'target_audience'.tr(),
                                    style: TextStyle(
                                      fontSize: AppDesignTokens.bodyFontSize,
                                      fontWeight: AppDesignTokens.semiBold,
                                      color: AppDesignTokens.titleTextColor,
                                    ),
                                  ),
                                  const fw.SizedBox(
                                    height: AppDesignTokens.smallGap,
                                  ),
                                  Wrap(
                                    spacing: AppDesignTokens.smallGap,
                                    runSpacing: AppDesignTokens.smallGap,
                                    children: [
                                      _TargetAudienceChip(
                                        label: 'all'.tr(),
                                        value: 0,
                                        selectedValue:
                                            cubit.selectedTargetAudience,
                                        onSelected: (value) {
                                          cubit.selectTargetAudience(value);
                                          cubit
                                                  .updateProductParams
                                                  .targetAudience =
                                              value;
                                        },
                                      ),
                                      _TargetAudienceChip(
                                        label: 'men'.tr(),
                                        value: 1,
                                        selectedValue:
                                            cubit.selectedTargetAudience,
                                        onSelected: (value) {
                                          cubit.selectTargetAudience(value);
                                          cubit
                                                  .updateProductParams
                                                  .targetAudience =
                                              value;
                                        },
                                      ),
                                      _TargetAudienceChip(
                                        label: 'women'.tr(),
                                        value: 2,
                                        selectedValue:
                                            cubit.selectedTargetAudience,
                                        onSelected: (value) {
                                          cubit.selectTargetAudience(value);
                                          cubit
                                                  .updateProductParams
                                                  .targetAudience =
                                              value;
                                        },
                                      ),
                                      _TargetAudienceChip(
                                        label: 'kids'.tr(),
                                        value: 3,
                                        selectedValue:
                                            cubit.selectedTargetAudience,
                                        onSelected: (value) {
                                          cubit.selectTargetAudience(value);
                                          cubit
                                                  .updateProductParams
                                                  .targetAudience =
                                              value;
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.cardGap),

                    // Status section: active switch
                    AppCard(
                      elevated: true,
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                        children: [
                          _FormSectionHeader(title: 'status'.tr()),
                          const fw.SizedBox(height: AppDesignTokens.sectionGap),

                          // Active Switch
                          BlocBuilder<ProductCubit, ProductState>(
                            builder: (context, state) {
                              return fw.Row(
                                mainAxisAlignment:
                                    fw.MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'active'.tr(),
                                    style: TextStyle(
                                      fontSize: AppDesignTokens.bodyFontSize,
                                      fontWeight: AppDesignTokens.semiBold,
                                      color: AppDesignTokens.titleTextColor,
                                    ),
                                  ),
                                  Switch(
                                    value:
                                        cubit.updateProductParams.isActive,
                                    onChanged: (value) {
                                      cubit.updateProductParams.isActive =
                                          value;
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
                    const fw.SizedBox(height: AppDesignTokens.sectionGap),

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
                            title: Text('success'.tr()),
                            content: Text(
                              'product_updated_successfully'.tr(),
                            ),
                            actions: [
                              PrimaryButton(
                                onPressed: () {
                                  fw.Navigator.pop(ctx);
                                  fw.Navigator.pop(
                                    context,
                                    true,
                                  ); // Return true to indicate success
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
                            content: Text(
                              'failed_to_update_product'.tr(args: ['$error']),
                            ),
                            actions: [
                              PrimaryButton(
                                onPressed: () => fw.Navigator.pop(ctx),
                                child: Text('ok'.tr()),
                              ),
                            ],
                          ),
                        );
                      },
                      child: PrimaryButton(
                        child: Text('update_product'.tr()),
                      ),
                    ),
                  ],
                ),
              )),
      ),
    );
  }

  void _showCategorySelector(BuildContext context, ProductCubit cubit) {
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider(
        create: (context) => CategoryCubit(),
        child: AlertDialog(
          title: Text('select_category'.tr()),
          content: fw.SizedBox(
            width: double.maxFinite,
            height: 400,
            child: PaginationList<CategoryModel>(
              withPagination: true,
              withRefresh: false,
              loadingWidget: SelectorListSkeleton(withSubtitle: false),
            repositoryCallBack: (data) {
                return context.read<CategoryCubit>().fetchCategoryList(data);
              },
              listBuilder: (list) {
                return fw.ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final category = list[index];
                    return SelectorTile(
                    title: category.name ?? 'N/A',
                    onTap: () {
                        if (category.id != null && category.name != null) {
                          cubit.selectCategory(category.id!);
                          cubit.updateProductParams.categoryId = category.id!;
                          _categoryIdController.text = category.name!;
                        }
                        fw.Navigator.pop(ctx);
                      },
                  );
                  },
                );
              },
            ),
          ),
          actions: [
            SecondaryButton(
              onPressed: () => fw.Navigator.pop(ctx),
              child: Text('cancel'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small bold section header used to group related fields inside a form
/// card (e.g. Media / Basics / Classification / Status).
class _FormSectionHeader extends StatelessWidget {
  final String title;

  const _FormSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: AppDesignTokens.cardTitleFontSize,
        fontWeight: AppDesignTokens.bold,
        color: AppDesignTokens.titleTextColor,
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
