import 'package:flutter/material.dart';
import '../../constant/app_colors/app_colors.dart';
import '../../constant/text_styles/app_text_style.dart';
import '../../constant/text_styles/font_size.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final Color? borderColor;
  final String? hintText;
  final String? errorText;
  final String? initValue;
  final Widget? prefixIcon;
  final Widget? labelWidget;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool isObscure;
  final bool? readOnly;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? paddingTop;
  final VoidCallback? onComplete;
  final Function(String? value)? validator;
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;
  final Function(String value)? onChanged;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;

  const CustomTextFormField({
    super.key,
    this.borderRadius,
    this.labelWidget,
    this.validator,
    this.labelText,
    this.minLines,
    this.textAlign,
    this.labelStyle,
    this.textInputAction,
    this.errorText,
    this.paddingTop,
    this.borderColor,
    this.isObscure = false,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.initValue,
    this.keyboardType,
    this.height,
    this.readOnly,
    this.onComplete,
    this.onChanged,
    this.width,
    this.maxLines = 1,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        focusNode: focusNode,
        initialValue: initValue,
        validator: (validator != null) ? (value) => validator!(value) : null,
        minLines: minLines,
        maxLines: maxLines,
        textInputAction: textInputAction ?? TextInputAction.next,
        textAlign: textAlign ?? TextAlign.start,
        onChanged: (value) {
          if (onChanged != null) onChanged!(value);
        },
        onEditingComplete: onComplete,
        readOnly: readOnly ?? false,
        keyboardType: keyboardType,
        style:
            textStyle ??
            AppTextStyle.getMediumStyle(
              color: AppColors.black1c,
              fontSize: AppFontSize.size_14,
            ),
        obscureText: isObscure,
        controller: controller,
        cursorColor: Colors.deepOrange,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.only(left: 15, top: paddingTop ?? 0),
          hintStyle:
              hintStyle ??
              AppTextStyle.getMediumStyle(
                color: AppColors.black1c.withValues(alpha: 0.8),
                fontSize: AppFontSize.size_12,
              ),
          hintText: hintText,
          prefixIcon: prefixIcon,
          filled: true,
          enabled: true,
          fillColor: fillColor ?? Colors.transparent,
          border: InputBorder.none,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            borderSide: BorderSide(color: borderColor ?? AppColors.greyDD),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: borderColor ?? AppColors.greyDD),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            borderSide: BorderSide(color: borderColor ?? AppColors.greyDD),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            borderSide: BorderSide(color: borderColor ?? AppColors.greyDD),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
            borderSide: const BorderSide(color: Colors.red),
          ),
          labelText: labelWidget == null ? labelText : null,
          label: labelWidget != null
              ? Center(child: Text(labelText ?? ''))
              : null,
          labelStyle:
              labelStyle ??
              AppTextStyle.getBoldStyle(
                color: Theme.of(context).colorScheme.primaryColor,
                fontSize: AppFontSize.size_14,
              ),
          errorText: errorText,
          suffixIcon: suffixIcon,
          errorStyle: AppTextStyle.getRegularStyle(
            fontSize: AppFontSize.size_14,
            color: Colors.red,
          ),
          errorMaxLines: 2,
        ),
      ),
    );
  }
}
