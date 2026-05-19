import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/core/utils/Navigation/navigation.dart';
import 'dart:io';
import '../../../constant/app_colors/app_colors.dart';
import '../../../constant/app_icons/app_icons.dart';
import '../../../constant/text_styles/app_text_style.dart';
import '../../../constant/text_styles/font_size.dart';

void showUploadOptionsForDocumentBottomSheet(
  BuildContext context, {
  Function(File)? onImageSelected,
}) {
  showModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withAlpha((0.2 * 255).toInt()),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Choose method to upload image",
                  style: AppTextStyle.getBoldStyle(
                    color: AppColors.grey9A,
                    fontSize: AppFontSize.size_16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _UploadOptionButton(
              icon: imageIcon,
              text: "Select photo from gallery",
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );

                if (image != null) {
                  final File file = File(image.path);
                  Navigation.pop();
                  onImageSelected?.call(file);
                }
              },
            ),
            const SizedBox(height: 16),
            _UploadOptionButton(
              icon: cameraIcon,
              text: "Take live photo",
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );

                if (image != null) {
                  final File file = File(image.path);
                  Navigation.pop();
                  onImageSelected?.call(file);
                }
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

class _UploadOptionButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback? onTap;

  const _UploadOptionButton({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
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
}
