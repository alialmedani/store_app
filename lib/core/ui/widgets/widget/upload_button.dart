import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constant/app_colors/app_colors.dart';
import '../../../constant/app_icons/app_icons.dart';
import '../../../constant/text_styles/app_text_style.dart';
import '../../../constant/text_styles/font_size.dart';

class UploadButton extends StatelessWidget {
  final VoidCallback onTap;

  const UploadButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              cameraIcon,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              width: 18,
              height: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "Upload file",
              style: AppTextStyle.getBoldStyle(
                color: Colors.white,
                fontSize: AppFontSize.size_14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}