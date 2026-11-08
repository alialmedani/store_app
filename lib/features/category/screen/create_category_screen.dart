import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
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
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryCubit>();

    return Scaffold(
      child: SafeArea(
        child: ScrollAwayHeader(header: Column(children: [
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
                  Expanded(
                    child: Text(
                      'create_category'.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )]), body: SingleChildScrollView(
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
                                Text(
                                  'category_name'.tr(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _nameController,
                                  placeholder: Text(
                                    'enter_category_name'.tr(),
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
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
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
                        Text(
                          'description'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          placeholder: Text(
                            'enter_description_optional'.tr(),
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
                                Text(
                                  'category_image_optional'.tr(),
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
                                        borderRadius: BorderRadius.circular(AppDesignTokens.badgeRadius),
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
                                        Text('select_image'.tr()),
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
                                Text(
                                  'size_type'.tr(),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      cubit.sizeTypeError!,
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
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
                                Text(
                                  'active'.tr(),
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
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      Navigator.pop(context); // Go back to list
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
                                  'failed_to_create_category'.tr(args: ['${error}']),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
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
              )),
      ),
    );
  }
}

/// Size Type Chip Widget for selection
class _SizeTypeChip extends StatelessWidget {
  final String label;
  final SizeType value;
  final SizeType? selectedValue;
  final Function(SizeType) onSelected;

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
          borderRadius: BorderRadius.circular(AppDesignTokens.badgeRadius),
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
