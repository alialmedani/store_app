import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constant/app_colors/app_colors.dart';
import '../../../constant/app_icons/app_icons.dart';
import '../../../constant/text_styles/app_text_style.dart';
import '../../../constant/text_styles/font_size.dart';
import '../cubit/document_cubit.dart';

class ImageUploadWidget extends StatelessWidget {
  /// Type of entity for upload
  final int? entityType;

  /// Master ID for upload
  final String? masterId;

  /// Master type for upload
  final String? masterType;

  /// Callback when images are selected (optional, cubit handles state)
  final Function(List<File>)? onImagesSelected;

  /// Show save button if only photo and masterType are provided
  final bool showSaveButton;

  /// Maximum number of images allowed
  final int maxImages;

  /// Title text above the upload area
  final String? title;

  /// Helper text below the title
  final String? helperText;

  const ImageUploadWidget({
    super.key,
    this.entityType,
    this.masterId,
    this.masterType,
    this.onImagesSelected,
    this.showSaveButton = false,
    this.maxImages = 5,
    this.title,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    // Set upload parameters when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentCubit>().setUploadParameters(
        entityType: entityType,
        masterId: masterId,
        masterType: masterType,
      );
    });

    return BlocListener<DocumentCubit, DocumentState>(
      listener: (context, state) {
        if (state is DocumentUploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم رفع الملفات بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is DocumentUploadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<DocumentCubit, DocumentState>(
        builder: (context, state) {
          final cubit = context.read<DocumentCubit>();
          final selectedImages = cubit.selectedImages;
          final isUploading = state is DocumentUploading;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: AppTextStyle.getMediumStyle(
                    color: AppColors.red,
                    fontSize: AppFontSize.size_16,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Upload area
              _buildUploadArea(context, selectedImages),

              if (helperText != null) ...[
                const SizedBox(height: 8),
                Text(
                  helperText!,
                  style: AppTextStyle.getRegularStyle(
                    color: AppColors.red,
                    fontSize: AppFontSize.size_14,
                  ),
                ),
              ],

              // Selected images grid
              if (selectedImages.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSelectedImagesGrid(context, selectedImages),
              ],

              // Save button (only if showSaveButton is true)
              if (showSaveButton && selectedImages.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSaveButton(context, isUploading),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildUploadArea(BuildContext context, List<File> selectedImages) {
    if (selectedImages.isEmpty) {
      // Show upload placeholder
      return _buildUploadPlaceholder(context);
    } else if (selectedImages.length < maxImages) {
      // Show add more button
      return _buildAddMoreButton(context);
    } else {
      // Max images reached
      return const SizedBox.shrink();
    }
  }

  Widget _buildUploadPlaceholder(BuildContext context) {
    return DottedBorder(
      options: CustomPathDottedBorderOptions(
        color: AppColors.primary,
        strokeWidth: 2,
        dashPattern: [8, 4],
        customPath: (size) => Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.width, size.height),
              const Radius.circular(12),
            ),
          ),
      ),
      child: InkWell(
        onTap: () => _showUploadOptions(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PDF and IMG icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'PDF',
                      style: AppTextStyle.getBoldStyle(
                        color: Colors.white,
                        fontSize: AppFontSize.size_12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'IMG',
                      style: AppTextStyle.getBoldStyle(
                        color: Colors.white,
                        fontSize: AppFontSize.size_12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Main title
              Text(
                'قم برفع الملف',
                style: AppTextStyle.getMediumStyle(
                  color: AppColors.red,
                  fontSize: AppFontSize.size_18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Helper text
              Text(
                '( أقصى حجم 2MB )',
                style: AppTextStyle.getRegularStyle(
                  color: AppColors.red,
                  fontSize: AppFontSize.size_14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Upload button
              ElevatedButton.icon(
                onPressed: () => _showUploadOptions(context),
                icon: const Icon(Icons.upload_file, color: AppColors.primary),
                label: Text(
                  'رفع الملف',
                  style: AppTextStyle.getMediumStyle(
                    color: AppColors.primary,
                    fontSize: AppFontSize.size_16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddMoreButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(top: 8),
      child: DottedBorder(
        options: CustomPathDottedBorderOptions(
          color: AppColors.primary,
          strokeWidth: 1.5,
          dashPattern: [6, 4],
          customPath: (size) => Path()
            ..addRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(0, 0, size.width, size.height),
                const Radius.circular(8),
              ),
            ),
        ),
        child: InkWell(
          onTap: () => _showUploadOptions(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'إضافة صورة أخرى',
                  style: AppTextStyle.getMediumStyle(
                    color: AppColors.primary,
                    fontSize: AppFontSize.size_14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImagesGrid(
    BuildContext context,
    List<File> selectedImages,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: selectedImages.length,
      itemBuilder: (context, index) {
        return _buildImageCard(context, selectedImages[index], index);
      },
    );
  }

  Widget _buildImageCard(BuildContext context, File image, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(context, index),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isUploading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isUploading ? null : () => _saveImages(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: isUploading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'حفظ',
                style: AppTextStyle.getMediumStyle(
                  color: Colors.white,
                  fontSize: AppFontSize.size_16,
                ),
              ),
      ),
    );
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (buildContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'اختر طريقة رفع الصورة',
                        style: AppTextStyle.getBoldStyle(
                          color: AppColors.red,
                          fontSize: AppFontSize.size_16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(buildContext),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Gallery option
                _buildUploadOptionTile(
                  context: context,
                  icon: imageIcon,
                  text: 'اختيار من المعرض',
                  onTap: () => _pickImage(context, ImageSource.gallery),
                ),
                const SizedBox(height: 16),

                // Camera option
                _buildUploadOptionTile(
                  context: context,
                  icon: cameraIcon,
                  text: 'التقاط صورة',
                  onTap: () => _pickImage(context, ImageSource.camera),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadOptionTile({
    required BuildContext context,
    required String icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyle.getMediumStyle(
                  color: AppColors.red,
                  fontSize: AppFontSize.size_16,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      Navigator.pop(context); // Close bottom sheet

      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null && context.mounted) {
        final File file = File(pickedFile.path);
        final cubit = context.read<DocumentCubit>();

        cubit.addImage(file);

        // Notify parent widget
        onImagesSelected?.call(cubit.selectedImages);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _removeImage(BuildContext context, int index) {
    final cubit = context.read<DocumentCubit>();
    cubit.removeImage(index);

    // Notify parent widget
    onImagesSelected?.call(cubit.selectedImages);
  }

  Future<void> _saveImages(BuildContext context) async {
    final cubit = context.read<DocumentCubit>();
    if (cubit.selectedImages.isEmpty) return;

    try {
      // Use uploadCurrentUserDocument for save button functionality
      await cubit.uploadCurrentUserDocument();
    } catch (e) {
      debugPrint('Error saving images: $e');
    }
  }
}
