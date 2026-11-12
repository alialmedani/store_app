import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/constant/enum/enum.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

/// Create Category Screen - Form to create new category
/// Uses CreateModel widget for state management
class CreateCategoryScreen extends fw.StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  fw.State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends fw.State<CreateCategoryScreen> {
  final _nameController = fw.TextEditingController();
  final _descriptionController = fw.TextEditingController();
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

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      cubit.setNameError('category_name_is_required'.tr());
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
  fw.Widget build(fw.BuildContext context) {
    final cubit = context.read<CategoryCubit>();

    return Scaffold(
      child: SafeArea(
        child: ScrollAwayHeader(
          header: fw.Column(
            children: [
              AppHeader(
                title: 'create_category'.tr(),
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
                            placeholder: 'enter_category_name'.tr(),
                            errorText: cubit.nameError,
                            onChanged: (value) {
                              cubit.createCategoryParams.name = value;
                              cubit.clearNameError();
                            },
                          );
                        },
                      ),
                      const fw.SizedBox(height: AppDesignTokens.itemGap),
                      AppTextField(
                        label: 'description'.tr(),
                        controller: _descriptionController,
                        placeholder: 'enter_description_optional'.tr(),
                        maxLines: 3,
                        onChanged: (value) {
                          cubit.createCategoryParams.description = value;
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
                      AppSectionTitle('category_image_optional'.tr()),
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
                                    onPressed: () {
                                      cubit.clearImageFile();
                                    },
                                    variance: ButtonVariance.destructive,
                                  ),
                                ),
                              ],
                            );
                          }
                          return OutlineButton(
                            onPressed: cubit.isUploadingImage
                                ? null
                                : () => _pickImage(cubit),
                            child: fw.Row(
                              mainAxisAlignment: fw.MainAxisAlignment.center,
                              children: [
                                fw.Icon(
                                  Icons.image_outlined,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const fw.SizedBox(width: AppDesignTokens.smallGap),
                                Text('select_image'.tr()),
                              ],
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
                      const fw.SizedBox(height: AppDesignTokens.itemGap),
                      BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          return fw.Column(
                            crossAxisAlignment: fw.CrossAxisAlignment.start,
                            children: [
                              fw.Wrap(
                                spacing: AppDesignTokens.smallGap,
                                runSpacing: AppDesignTokens.smallGap,
                                children: [
                                  _SizeTypeChip(
                                    label: 'none'.tr(),
                                    value: SizeType.none,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: cubit.selectSizeType,
                                  ),
                                  _SizeTypeChip(
                                    label: 'clothing'.tr(),
                                    value: SizeType.clothing,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: cubit.selectSizeType,
                                  ),
                                  _SizeTypeChip(
                                    label: 'shoes'.tr(),
                                    value: SizeType.shoes,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: cubit.selectSizeType,
                                  ),
                                  _SizeTypeChip(
                                    label: 'one_size'.tr(),
                                    value: SizeType.oneSize,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: cubit.selectSizeType,
                                  ),
                                  _SizeTypeChip(
                                    label: 'kids_age'.tr(),
                                    value: SizeType.kidsAge,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: cubit.selectSizeType,
                                  ),
                                  _SizeTypeChip(
                                    label: 'custom'.tr(),
                                    value: SizeType.custom,
                                    selectedValue: cubit.selectedSizeType,
                                    onSelected: cubit.selectSizeType,
                                  ),
                                ],
                              ),
                              if (cubit.sizeTypeError != null)
                                fw.Padding(
                                  padding: const fw.EdgeInsets.only(
                                    top: AppDesignTokens.smallGap,
                                  ),
                                  child: Text(
                                    cubit.sizeTypeError!,
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
                          Text(
                            'active'.tr(),
                            style: const fw.TextStyle(
                              fontSize: AppDesignTokens.bodyFontSize,
                              fontWeight: AppDesignTokens.semiBold,
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
                    return cubit.createCategoryWithImage();
                  },
                  onSuccess: (categoryModel) {
                    // Clear form
                    cubit.createCategoryParams.name = '';
                    cubit.createCategoryParams.description = '';
                    cubit.createCategoryParams.sizeType = 0;
                    cubit.createCategoryParams.isActive = true;
                    cubit.selectedSizeType = SizeType.none;
                    cubit.clearImageFile();
                    cubit.clearAllErrors();

                    // Show success dialog
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('success'.tr()),
                        content: Text(
                          'category_created_successfully'.tr(),
                        ),
                        actions: [
                          PrimaryButton(
                            onPressed: () {
                              fw.Navigator.pop(ctx);
                              fw.Navigator.pop(context); // Go back to list
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
                          'failed_to_create_category'.tr(args: ['$error']),
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
                    child: Text('create_category'.tr()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Size Type Chip Widget for selection
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
