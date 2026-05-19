import 'package:flutter/material.dart';
import 'package:store/core/constant/app_colors/app_colors.dart';
 
enum AppTheme { dark, light }

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.light: ThemeData(
    primaryColor: AppColors.white,
    scaffoldBackgroundColor: AppColors.white,
    brightness: Brightness.light,
    secondaryHeaderColor: AppColors.lightSubHeadingColor1,
    fontFamily: "Montserrat",
  ),
  AppTheme.dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimaryColor,
    secondaryHeaderColor: AppColors.darkSubHeadingColor1,
    scaffoldBackgroundColor: AppColors.darkPrimaryColor,
    fontFamily: "Montserrat",
  )
};
