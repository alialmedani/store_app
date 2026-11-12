import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../../core/constant/enum/enum.dart';
import '../../../../core/ui/widgets/authenticated_image.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../../../core/utils/image_helper.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';
import 'package:easy_localization/easy_localization.dart';

/// Edit Category Screen - Form to edit existing category
/// Uses CreateModel widget for state management
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
  }

  bool _validateFields(CategoryCubit cubit) {
    bool isValid = true;

    if (_nameController.text.trim().isEmpty) {
      cubit.setNameError('category_name_is_required'.tr());
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
    final cubit = context.read<CategoryCubit>();

    return Scaffold(
      child: SafeArea(
        child: GetModel<CategoryModel>(
          useCaseCallBack: () => cubit.getCategoryDetails(widget.categoryId),
          modelBuilder: (category) {
            _initializeFields(category, cubit);
            final imageUrl = ImageHelper.getCategoryImageUrl(category.id ?? '');

            return ScrollAwayHeader(
              header: fw.Column(
                children: [
                  AppHeader(
                    title: 'edit_category'.tr(),
                    onBack: () => fw.Navigator.pop(context),
                  ),
                ],
              ),
              body: fw.SingleChildScrollView(
                padding: const fw.EdgeInsets.fromLTRB(
                  AppDesignTokens.screenPaddingHorizontal,
                  0,
                  AppDesignTokens.screenPaddingHorizontal,
                  AppDesignTokens.listBottomPadding,
                ),
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                  children: [
                    // Basic info section
                    AppCard(
                      elevated: true,
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          AppSectionTitle('basic_information'.tr()),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),
                          BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              return AppTextField(
                                label: 'category_name'.tr(),
                                controller: _nameController,
                                placeholder:
                                    'enter_a_descriptive_category_name'.tr(),
                                errorText: cubit.nameError,
                                onChanged: (value) {
                                  cubit.updateCategoryParams.name = value;
                                  cubit.clearNameError();
                                },
                              );
                            },
                          ),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),
                          AppTextField(
                            label: 'description'.tr(),
                            controller: _descriptionController,
                            placeholder:
                                'add_a_brief_description_about_this_cat'.tr(),
                            maxLines: 4,
                            onChanged: (value) {
                              cubit.updateCategoryParams.description = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.cardGap),

                    // Image section
                    AppCard(
                      elevated: true,
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          AppSectionTitle('category_image'.tr()),
                          const fw.SizedBox(height: AppDesignTokens.tinyGap),
                          Text(
                            'optional_recommended_size_800x600'.tr(),
                            style: fw.TextStyle(
                              fontSize: AppDesignTokens.captionFontSize,
                              color: AppDesignTokens.mutedTextColor,
                            ),
                          ),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),
                          BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              if (cubit.selectedImageFile != null) {
                                return fw.Stack(
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
                                      top: AppDesignTokens.smallGap,
                                      right: AppDesignTokens.smallGap,
                                      child: IconButton(
                                        icon: const fw.Icon(Icons.close),
                                        onPressed: () => cubit.clearImageFile(),
                                        variance: ButtonVariance.destructive,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              if (imageUrl.isNotEmpty) {
                                return fw.Stack(
                                  children: [
                                    fw.ClipRRect(
                                      borderRadius: fw.BorderRadius.circular(
                                        AppDesignTokens.inputRadius,
                                      ),
                                      child: AuthenticatedImage(
                                        imageUrl: imageUrl,
                                        width: double.infinity,
                                        height: 200,
                                        fit: fw.BoxFit.cover,
                                        errorWidget: fw.Container(
                                          color: AppDesignTokens.mutedSurfaceColor,
                                          child: fw.Center(
                                            child: fw.Icon(
                                              Icons.category_outlined,
                                              size: 56,
                                              color: AppDesignTokens.mutedTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    fw.Positioned(
                                      bottom: AppDesignTokens.smallGap,
                                      right: AppDesignTokens.smallGap,
                                      child: SecondaryButton(
                                        onPressed: () => _pickImage(cubit),
                                        child: fw.Row(
                                          mainAxisSize: fw.MainAxisSize.min,
                                          children: [
                                            const fw.Icon(Icons.edit, size: 16),
                                            const fw.SizedBox(
                                              width: AppDesignTokens.smallGap,
                                            ),
                                            Text('change_image'.tr()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return fw.GestureDetector(
                                onTap: () => _pickImage(cubit),
                                child: fw.Container(
                                  height: 160,
                                  decoration: fw.BoxDecoration(
                                    color: AppDesignTokens.mutedSurfaceColor,
                                    borderRadius: fw.BorderRadius.circular(
                                      AppDesignTokens.inputRadius,
                                    ),
                                    border: fw.Border.all(
                                      color: AppDesignTokens.borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: fw.Center(
                                    child: fw.Column(
                                      mainAxisAlignment:
                                          fw.MainAxisAlignment.center,
                                      children: [
                                        fw.Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 40,
                                          color: AppDesignTokens.primaryColor,
                                        ),
                                        const fw.SizedBox(
                                          height: AppDesignTokens.smallGap,
                                        ),
                                        Text(
                                          'click_to_upload_image'.tr(),
                                          style: fw.TextStyle(
                                            fontSize: AppDesignTokens.bodyFontSize,
                                            fontWeight: AppDesignTokens.semiBold,
                                            color: AppDesignTokens.primaryColor,
                                          ),
                                        ),
                                        const fw.SizedBox(
                                          height: AppDesignTokens.tinyGap,
                                        ),
                                        Text(
                                          'png_jpg_up_to_10mb'.tr(),
                                          style: fw.TextStyle(
                                            fontSize:
                                                AppDesignTokens.smallCaptionFontSize,
                                            color: AppDesignTokens.mutedTextColor,
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

                    // Size type section
                    AppCard(
                      elevated: true,
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          AppSectionTitle('size_type'.tr()),
                          const fw.SizedBox(height: AppDesignTokens.tinyGap),
                          Text(
                            'choose_the_appropriate_sizing_system'.tr(),
                            style: fw.TextStyle(
                              fontSize: AppDesignTokens.captionFontSize,
                              color: AppDesignTokens.mutedTextColor,
                            ),
                          ),
                          const fw.SizedBox(height: AppDesignTokens.itemGap),
                          BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, state) {
                              return fw.Wrap(
                                spacing: AppDesignTokens.smallGap,
                                runSpacing: AppDesignTokens.smallGap,
                                children: [
                                  _SizeTypeChip(
                                    label: 'none'.tr(),
                                    value: SizeType.none,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: (value) {
                                      cubit.selectSizeType(value);
                                      cubit.updateCategoryParams.sizeType =
                                          value.toInt();
                                    },
                                  ),
                                  _SizeTypeChip(
                                    label: 'clothing'.tr(),
                                    value: SizeType.clothing,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: (value) {
                                      cubit.selectSizeType(value);
                                      cubit.updateCategoryParams.sizeType =
                                          value.toInt();
                                    },
                                  ),
                                  _SizeTypeChip(
                                    label: 'shoes'.tr(),
                                    value: SizeType.shoes,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: (value) {
                                      cubit.selectSizeType(value);
                                      cubit.updateCategoryParams.sizeType =
                                          value.toInt();
                                    },
                                  ),
                                  _SizeTypeChip(
                                    label: 'one_size'.tr(),
                                    value: SizeType.oneSize,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: (value) {
                                      cubit.selectSizeType(value);
                                      cubit.updateCategoryParams.sizeType =
                                          value.toInt();
                                    },
                                  ),
                                  _SizeTypeChip(
                                    label: 'kids_age'.tr(),
                                    value: SizeType.kidsAge,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: (value) {
                                      cubit.selectSizeType(value);
                                      cubit.updateCategoryParams.sizeType =
                                          value.toInt();
                                    },
                                  ),
                                  _SizeTypeChip(
                                    label: 'custom'.tr(),
                                    value: SizeType.custom,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: (value) {
                                      cubit.selectSizeType(value);
                                      cubit.updateCategoryParams.sizeType =
                                          value.toInt();
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.cardGap),

                    // Status section
                    AppCard(
                      elevated: true,
                      child: BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          return fw.Row(
                            mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
                            children: [
                              fw.Expanded(
                                child: fw.Column(
                                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'category_status'.tr(),
                                      style: const fw.TextStyle(
                                        fontSize: AppDesignTokens.bodyFontSize,
                                        fontWeight: AppDesignTokens.semiBold,
                                      ),
                                    ),
                                    const fw.SizedBox(
                                      height: AppDesignTokens.tinyGap,
                                    ),
                                    Text(
                                      cubit.updateCategoryParams.isActive
                                          ? 'visible_to_customers'.tr()
                                          : 'hidden_from_store'.tr(),
                                      style: fw.TextStyle(
                                        fontSize: AppDesignTokens.captionFontSize,
                                        color: AppDesignTokens.mutedTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: cubit.updateCategoryParams.isActive,
                                onChanged: (value) {
                                  cubit.updateCategoryParams.isActive = value;
                                  cubit.toggleIsActive(value);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.sectionGap),

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
                            title: Text('success'.tr()),
                            content: Text(
                              'category_updated_successfully'.tr(),
                            ),
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
                            content: Text(
                              'failed_to_update_category'.tr(args: ['$error']),
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
                        child: Text('update_category'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
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
