import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:store/core/classes/cashe_helper.dart';
import 'package:store/core/constant/app_colors/app_colors.dart';
import 'package:store/core/constant/text_styles/app_text_style.dart';
import 'package:store/core/constant/text_styles/font_size.dart';
import 'package:store/core/ui/screens/splash_screen.dart';
import 'package:store/core/utils/Navigation/navigation.dart';


class LanguageSettingsRow extends StatelessWidget {
  const LanguageSettingsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final code = context.locale.languageCode;
    final currentName = _langName(context, code);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => showLanguageDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.profSurfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.profLightBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.profHoverColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.profLightBorder),
              ),
              child: Icon(
                Icons.language_outlined,
                size: 18,
                color: AppColors.profPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'settings_language'.tr(),
                    style: AppTextStyle.getBoldStyle(
                      fontSize: AppFontSize.size_14,
                      color: AppColors.profDarkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentName,
                    style: AppTextStyle.getRegularStyle(
                      fontSize: AppFontSize.size_12,
                      color: AppColors.profMediumText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.profMediumText,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  String _langName(BuildContext context, String code) {
    switch (code) {
      case 'en':
        return 'lang_en'.tr();
      case 'bn':
        return 'lang_bn'.tr();
      case 'ar':
        return 'lang_ar'.tr();
      default:
        return code;
    }
  }
}
 
Future<void> showLanguageDialog(BuildContext context) async {
  final current = context.locale.languageCode;

  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.35), // نفس إحساس overlay الراقي
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        backgroundColor: Colors.transparent,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.profSurfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.profLightBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.profHoverColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.profLightBorder),
                        ),
                        child: Icon(
                          Icons.language_outlined,
                          size: 18,
                          color: AppColors.profPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'settings_language'.tr(),
                          style: AppTextStyle.getBoldStyle(
                            fontSize: AppFontSize.size_15,
                            color: AppColors.profDarkText,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: AppColors.profMediumText,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _LangTile(
                    title: 'lang_en'.tr(),
                    selected: current == 'en',
                    onTap: () => _applyLang(dialogContext, 'en'),
                  ),
                  const SizedBox(height: 8),
                  _LangTile(
                    title: 'lang_bn'.tr(),
                    selected: current == 'bn',
                    onTap: () => _applyLang(dialogContext, 'bn'),
                  ),
                  const SizedBox(height: 8),
                  _LangTile(
                    title: 'lang_ar'.tr(),
                    selected: current == 'ar',
                    onTap: () => _applyLang(dialogContext, 'ar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> _applyLang(BuildContext dialogContext, String code) async {
  // نستخدم نفس context (easy_localization مربوط فيه)
  await dialogContext.setLocale(Locale(code));
  await CacheHelper.setLang(code);

  if (!dialogContext.mounted) return;

  Navigator.of(dialogContext).pop();

  ScaffoldMessenger.of(dialogContext).showSnackBar(
    SnackBar(
      content: Text('save_success'.tr()),
      backgroundColor: AppColors.profPrimary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ),
  );

  Navigation.pushAndRemoveUntil(SplashSscreen());
}

class _LangTile extends StatelessWidget {
  const _LangTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? AppColors.profHoverColor : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.profPrimary : AppColors.profLightBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.profPrimary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.profPrimary : AppColors.profLightBorder,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.getRegularStyle(
                  fontSize: AppFontSize.size_14,
                  color: selected ? AppColors.profDarkText : AppColors.profMediumText,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.done_rounded, size: 18, color: AppColors.profPrimary),
          ],
        ),
      ),
    );
  }
}
