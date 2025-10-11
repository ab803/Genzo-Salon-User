import 'package:flutter/material.dart';
import 'package:userbarber/Feature/Localization/Locales.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ProductListItem extends StatelessWidget {
  final String categoryKey;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductListItem({
    super.key,
    required this.categoryKey,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentyellow : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          categoryKey.getString(context), // localized only in UI
          style: AppTextStyles.body(
            isSelected ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ),
    );
  }
}
