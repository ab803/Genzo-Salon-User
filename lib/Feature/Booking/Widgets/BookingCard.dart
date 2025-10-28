import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/core/Models/bookingModel.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        leading: Icon(
          Icons.event_note,
          color: AppColors.accentyellow,
          size: 40,
        ),
        title: Text(
          booking.services.join(", "),
          style: AppTextStyles.subheading(
            isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        subtitle: Text(
          "${booking.date.day}/${booking.date.month}/${booking.date.year} "
          "${"at".getString(context)} ${booking.time.format(context)}",
          style: AppTextStyles.caption(
            isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
        trailing: Text(
          "priceWithCurrency"
              .getString(context)
              .replaceFirst("{price}", booking.totalPrice.toStringAsFixed(2)),
          style: AppTextStyles.body(AppColors.accentyellow),
        ),
      ),
    );
  }
}
