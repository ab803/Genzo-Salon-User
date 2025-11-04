import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

/// 🔹 Shows the total price section at bottom
class CartTotalSection extends StatelessWidget {
  final bool isDark;
  final double total;

  const CartTotalSection({
    super.key,
    required this.isDark,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "total".getString(context),
            style: AppTextStyles.subheading(
              isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          Text(
            "${"EGP".getString(context)} ${total.toStringAsFixed(2)}",
            style: AppTextStyles.subheading(AppColors.accentyellow),
          ),
        ],
      ),
    );
  }
}
