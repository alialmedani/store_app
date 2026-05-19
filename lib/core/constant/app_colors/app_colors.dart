import 'package:flutter/material.dart';

extension AppColors on ColorScheme {
  static const Color primary = Color(0xFFD20808);
  static const Color red = Color(0xFFD20808);

  // light Theme Colors
  static Color lightSecondaryColor = const Color(0xffFFFFFF);
  static Color lightSubHeadingColor1 = const Color(0xff343F53);
  // dark theme color
  static Color darkPrimaryColor = const Color(0xff1E1E2C);
  static Color darkSubHeadingColor1 = const Color(0xDDF2F1F6);
  //
  static Color xprimaryColor = const Color(0xffC67C4E);

  // static Color xsecondaryColor = const Color(0xffA2A2A2);

  // when switch color
  Color get blackColor => brightness == Brightness.light
      ? lightSubHeadingColor1
      : darkSubHeadingColor1;
  Color get primaryColor =>
      brightness == Brightness.light ? primary : darkSubHeadingColor1;
  Color get secondaryColor => brightness == Brightness.light
      ? lightSecondaryColor
      : darkSubHeadingColor1;

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black1c = Color(0xFF1C1C1C);
  static const Color black28 = Color(0xFF282828);
  static const Color black23 = Color(0xFF232323);
  static const Color black14 = Color(0xFF141414);
  static const Color grey9A = Color(0xFF9A9A9A);
  static const Color greyDD = Color(0xFFDDE2E4);
       static const Color grey8E = Color(0xFF8E8E8E);
   static const Color grey3B = Color(0xFF3B3B3B);
   static const Color secondPrimery = Color(0xFF727272);
  static const Color orange = Color(0xFFEC8600);
   static const Color greyE5 = Color(0xFFE5E5E5);
    static const Color green = Color(0xFF00B207);
    static const Color babyBlue = Color(0xFF87CEEB);

  // ========== الألوان الأنيقة الجديدة ==========
  // Primary - بني فاخر (متناسق مع Splash)

// Primary - زيتي راقي (المحور الرئيسي)
static const Color profPrimary = Color(0xFF57534E);      // Stone 600 (وسط)
static const Color profPrimaryLight = Color(0xFF8A857E); // Stone 400/500
static const Color profPrimaryDark = Color(0xFF292524);  // Stone 800 (استخدام قليل)

static const Color profAccentTeal = Color(0xFFA8A29E);   // Stone 400 (Accent)
static const Color profAccentAmber = Color(0xFFFAFAF9);  // Stone 50


static const Color profDarkText = Color(0xFF1C1917);
static const Color profMediumText = Color(0xFF78716C);
static const Color profLightBorder = Color(0xFFE7E5E4);
static const Color profSurfaceColor = Color(0xFFFFFFFF);
static const Color profHoverColor = Color(0xFFF5F5F4);

  // Status Colors - احترافية وواضحة
  static const Color profSuccessColor = Color(0xFF16A34A); // Green 600
  static const Color profWarningColor = Color(0xFFF59E0B); // Amber 500
  static const Color profErrorColor = Color(0xFFEF4444);   // Red 500







  // // Olive & Green Range
  // static const Color oliveGreen = Color(0xFF6B7D3D); // أخضر زيتي فاخر
  // static const Color oliveLight = Color(0xFF8B9D5D); // أخضر زيتي فاتح
  // static const Color mossGreen = Color(0xFF556B2F); // أخضر غابة عميق

  // // Beige & Warm Neutrals
  // static const Color beigeWarm = Color(0xFFF5DEB3); // بيج دافئ
  // static const Color taupe = Color(0xFFB38B6D); // بني رمادي ناعم
  // static const Color cream = Color(0xFFFFF8F0); // كريم دافئ جداً

  // // Accent Colors - دافئة وأنيقة
  // static const Color warmAccent = Color(0xFFD4A574); // ذهبي دافئ
  // static const Color rustAccent = Color(0xFFB85C3C); // صدأ احترافي
}
