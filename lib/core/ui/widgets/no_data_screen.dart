import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant/app_colors/app_colors.dart';
import '../../constant/app_images/app_images.dart';
import '../../constant/text_styles/app_text_style.dart';
import '../../constant/text_styles/font_size.dart';

class NoDataScreen extends StatelessWidget {
  final double? height;
  final double? width;
  const NoDataScreen({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width ?? 300.w,
                  maxHeight: height ?? 200.h,
                ),
                child: Image.asset(
                  noDataImage,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.h),
              Text("no data",
                  style: AppTextStyle.getRegularStyle(
                      color: AppColors.grey9A, fontSize: AppFontSize.size_16)),
            ],
          ),
        ),
      ),
    );
  }
}