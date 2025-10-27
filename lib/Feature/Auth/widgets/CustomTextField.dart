import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelKey;
  final String? validatorKey;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isDark;
  final int? maxLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelKey,
    this.validatorKey,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.isDark,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelKey.getString(context),
        labelStyle: AppTextStyles.body(
          isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.accentyellow)
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
          onTap: onSuffixTap,
          child: Icon(
            suffixIcon,
            color: AppColors.accentyellow,
          ),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText),
      validator: validatorKey == null
          ? null
          : (val) => val!.isEmpty ? validatorKey!.getString(context) : null,
    );
  }
}
