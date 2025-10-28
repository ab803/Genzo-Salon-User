import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__cubit.dart';
import 'package:userbarber/core/Models/bookingModel.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class BookingDetailsView extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsView({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          "bookingDetails".getString(context),
          style: AppTextStyles.heading(
            isDark ? AppColors.accentyellow : AppColors.primaryNavy,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.accentyellow : AppColors.primaryNavy,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Number
            Text(
              "${"booking".getString(context)} : ${booking.bookingNumber}",
              style: AppTextStyles.subheading(
                isDark ? Colors.white : AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 12),

            // Services
            Text(
              "${"services".getString(context)} : ${booking.services.join(", ")}",
              style: AppTextStyles.subheading(AppColors.accentyellow),
            ),
            const SizedBox(height: 12),

            // Date & Time
            Text(
              "${"date".getString(context)} & ${"time".getString(context)} : "
              "${booking.date.day}/${booking.date.month}/${booking.date.year} "
              "${"at".getString(context)} ${booking.time.format(context)}",
              style: AppTextStyles.body(
                isDark ? Colors.white70 : AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 12),

            // Price
            Text(
              "${"totalPrice".getString(context)} : "
              "${"priceWithCurrency".getString(context).replaceFirst("{price}", booking.totalPrice.toStringAsFixed(2))}",
              style: AppTextStyles.body(
                isDark ? Colors.white70 : AppColors.primaryNavy,
              ),
            ),
            Text(
              "paymentMethod".getString(context) +
                  " : " +
                  booking.PaymentMethod,
              style: AppTextStyles.body(
                isDark ? Colors.white70 : AppColors.primaryNavy,
              ),
            ),

            const Spacer(),

            // Cancel Booking Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  context.read<BookingCubit>().deleteBooking(
                    booking.bookingid,
                    booking.bookingNumber,
                  );
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: "bookingCanceled".getString(context),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                },
                child: Text(
                  "cancelBooking".getString(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
