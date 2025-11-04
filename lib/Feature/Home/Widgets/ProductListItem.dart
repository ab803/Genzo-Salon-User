import 'package:flutter/material.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

/// A widget that represents a single selectable product category item
/// used typically in horizontal category lists (e.g., "Haircut", "Beard", etc.)
class ProductListItem extends StatelessWidget {
  /// Localization key for the category name (e.g. "haircut", "beard")
  final String categoryKey;

  /// Indicates whether this category is currently selected
  final bool isSelected;

  /// Callback when the user taps on this item
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
      // Executes the provided callback when tapped
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8), // spacing between category items
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          // Yellow background when selected, otherwise light gray
          color: isSelected ? AppColors.accentyellow : Colors.grey[300],
          borderRadius: BorderRadius.circular(12), // smooth rounded edges
        ),
        child: Text(
          // Translates the category key based on current locale
          categoryKey.getString(context),

          // Uses custom text style, switching text color based on selection
          style: AppTextStyles.body(
            isSelected ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ),
    );
  }
}
