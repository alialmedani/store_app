import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant/app_colors/app_colors.dart';
import '../../constant/text_styles/app_text_style.dart';
import '../../constant/text_styles/font_size.dart';

class UploadOptionButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;

  const UploadOptionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
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
                  color: AppColors.grey9A,
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
