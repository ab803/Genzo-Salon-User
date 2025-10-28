import 'package:flutter/material.dart';
import 'package:userbarber/core/Models/OrderModel.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

class OrderHistoryCard extends StatelessWidget {
  final OrderModel order;

  const OrderHistoryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Number + Status
            Row(
              children: [
                Text(
                  "${'order'.getString(context)} ${order.orderNumber}",
                  style: AppTextStyles.subheading(AppColors.accentyellow),
                ),
                const Spacer(),
                Text(
                  _statusText(order.status, context),
                  style: AppTextStyles.subheading(_statusColor(order.status)),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Date
            Text(
              "${'date'.getString(context)}: ${order.orderDate}",
              style: AppTextStyles.caption(
                isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
            const SizedBox(height: 8),

            // Items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items
                  .map(
                    (item) => Text(
                      "- ${item.product.productName} x${item.quantity} (${item.product.productPrice} ${'egp'.getString(context)})",
                      style: AppTextStyles.caption(
                        isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                  )
                  .toList(),
            ),

            Divider(
              color: isDark ? Colors.white24 : Colors.black26,
              height: 20,
            ),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${'total'.getString(context)}: ${order.totalPrice} ${'egp'.getString(context)}",
                  style: AppTextStyles.subheading(
                    isDark ? AppColors.darkText : AppColors.lightText,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color _statusColor(String? status) {
  switch (status?.toLowerCase()) {
    case "completed":
      return Colors.green;
    case "canceled":
      return Colors.red;
    case "pending":
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

/// Localize status texts using flutter_localization
String _statusText(String? status, BuildContext context) {
  switch (status?.toLowerCase()) {
    case "completed":
      return 'completed'.getString(context);
    case "canceled":
      return 'canceled'.getString(context);
    case "pending":
      return 'pending'.getString(context);
    default:
      return 'unknown'.getString(context);
  }
}
