import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/PaymentWidgets/PaymentButton.dart';

import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

/// ✅ Global Reusable Bottom Sheet for Payment Method Selection
/// Can be used from Cart, Booking, or any screen.
class PaymentMethodSheet extends StatelessWidget {
  final bool isDark;
  final double total;
  final VoidCallback onCash;
  final VoidCallback onCard;

  const PaymentMethodSheet({
    super.key,
    required this.isDark,
    required this.total,
    required this.onCash,
    required this.onCard,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🏷️ Title
          Text(
            "Select Payment Method".getString(context),
            style: AppTextStyles.heading(
              isDark ? AppColors.accentyellow : AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 20),

          // 💵 Cash button
          PaymentButton(
            label: "cash".getString(context),
            color: AppColors.accentyellow,
            onPressed: onCash,
          ),
          const SizedBox(height: 12),

          // 💳 Credit card button
          PaymentButton(
            label: "Credit Card".getString(context),
            color: isDark
                ? AppColors.darkBackground
                : AppColors.primaryNavy,
            onPressed: onCard

          )],
      ),
    );
  }
}
