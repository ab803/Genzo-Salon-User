import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/Search/widgets/SearchUtilies.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

/// A single product tile that displays product name, category, and price.
class ProductTile extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isDark;
  final void Function(String id) onTap;

  const ProductTile({
    super.key,
    required this.product,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Extract product fields safely with default fallbacks
    final name = (product['productName']?.toString() ?? 'Unnamed product');
    final description =
    (product['ProductCategory']?.toString() ?? 'No description');
    final id = (product['id']?.toString() ?? '');
    final price = formatPrice(product['productPrice']);

    return ListTile(
      title: Text(
        name,
        style: AppTextStyles.subheading(
          isDark ? AppColors.darkText : AppColors.lightText,
        ),
      ),
      subtitle: Text(
        description,
        style: AppTextStyles.body(
          isDark
              ? AppColors.darkSecondaryText
              : AppColors.lightSecondaryText,
        ),
      ),
      trailing: Text(
        // Localized currency with formatted price
        "currencyEGP".getString(context).replaceFirst("{price}", price),
        style: AppTextStyles.subheading(AppColors.accentyellow),
      ),
      onTap: () => onTap(id), // navigate on tap
    );
  }
}
