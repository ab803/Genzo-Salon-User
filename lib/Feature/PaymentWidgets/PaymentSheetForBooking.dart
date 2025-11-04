import 'package:flutter/material.dart';
import 'package:userbarber/Feature/Booking/helper/ConfirmBooking.dart';
import 'package:userbarber/Feature/PaymentWidgets/PaymentMethodSheet.dart';
import 'package:userbarber/core/Styles/Styles.dart';

void showPaymentMethodSheetForBooking({required BuildContext context, required double total ,required DateTime? selectedDate,required TimeOfDay? selectedTime}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context : context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
    builder: (BuildContext context) {
      return PaymentMethodSheet(
          isDark: isDark,
          total: total,
          onCash: (){
            confirmBooking(
              context: context,
              paymentMethod: "Cash",
                selectedDate:selectedDate!,
              selectedTime: selectedTime!);

          },
          onCard: (){
            confirmBooking(
              context: context,
              paymentMethod: "Card",
                selectedDate:selectedDate!,
              selectedTime: selectedTime!);
          }
      );
    },
  );
}