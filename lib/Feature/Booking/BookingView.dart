import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userbarber/Feature/Booking/BookingHistory.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__cubit.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__state.dart';
import 'package:userbarber/Feature/Booking/Widgets/ConfirmBookingButton.dart';
import 'package:userbarber/Feature/Booking/Widgets/DatePickerField.dart';
import 'package:userbarber/Feature/Booking/Widgets/ServiceSelectionButtons.dart';
import 'package:userbarber/Feature/Booking/Widgets/TimePickerField.dart';
import 'package:userbarber/Feature/Booking/helper/DataPicker.dart';
import 'package:userbarber/Feature/Booking/helper/TimePicker.dart';
import 'package:userbarber/Feature/PaymentWidgets/PaymentSheetForBooking.dart';
import 'package:userbarber/Feature/PaymentWidgets/PaymentSheetForOrders.dart';
import 'package:userbarber/core/Services/PaymobManager/Constants.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Utilities/serviceList.dart';
import 'package:userbarber/Feature/Home/Widgets/ScaffoldWithNav.dart';



class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  double get totalPrice =>
      globalServiceCartItems.fold(0.0, (sum, s) => sum + s.price);
  List<String> get selectedServices =>
      globalServiceCartItems.map((s) => s.name).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaffoldWithNav(
      selectedIndex: 1,
      child: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingActionSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Book Appointment',
                            style: AppTextStyles.heading(
                              isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.history),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BookingHistoryView(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Services
                      ServiceSelectionButtons(totalPrice: totalPrice),

                      const SizedBox(height: 20),

                      // Date Picker
                      DatePickerField(
                        selectedDate: selectedDate,
                        onTap: () async {
                          final date = await pickBookingDate(context, selectedDate);
                          if (date != null) setState(() => selectedDate = date);
                        },
                      ),

                      const SizedBox(height: 20),

                      // Time Picker
                      TimePickerField(
                        selectedTime: selectedTime,
                        onTap: () async {
                          final time = await pickBookingTime(context);
                          if (time != null) setState(() => selectedTime = time);
                        },
                      ),

                      const SizedBox(height: 30),

                      // Confirm Booking
                      ConfirmBookingButton(
                        onPressed: () {
                          showPaymentMethodSheetForBooking(
                             context: context,
                              total: totalPrice,
                              selectedDate: selectedDate!,
                              selectedTime: selectedTime!,

                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Loading overlay
              if (state is BookingLoading)
                Container(
                  color: const Color.fromRGBO(0, 0, 0, 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentyellow,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
