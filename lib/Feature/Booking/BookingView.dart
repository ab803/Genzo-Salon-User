import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userbarber/Feature/Booking/BookingHistory.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__cubit.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__state.dart';
import 'package:userbarber/Feature/Booking/Widgets/ConfirmBookingButton.dart';
import 'package:userbarber/Feature/Booking/Widgets/DatePickerField.dart';
import 'package:userbarber/Feature/Booking/Widgets/PaymentMethodSheet.dart';
import 'package:userbarber/Feature/Booking/Widgets/ServiceSelectionButtons.dart';
import 'package:userbarber/Feature/Booking/Widgets/TimePickerField.dart';
import 'package:userbarber/Feature/Booking/Widgets/serviceButton.dart';
import 'package:userbarber/core/Services/PaymobManager/Constants.dart';
import 'package:userbarber/core/Services/PaymobManager/PatmobManager.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Models/bookingModel.dart';
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

  double get totalPrice => globalServiceCartItems.fold(0.0, (sum, s) => sum + s.price);
  List<String> get selectedServices => globalServiceCartItems.map((s) => s.name).toList();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) setState(() => selectedTime = time);
  }

  Future<void> pay() async {
    try {
      String paymentKey = await PaymobManager().getPaymentKey(totalPrice.toInt(), "EGP");
      final url =
          "https://accept.paymob.com/api/acceptance/iframes/${Constants.iframeId}?payment_token=$paymentKey";
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print("❌ Payment failed: $e");
    }
  }

  Future<void> _addToGoogleCalendar(DateTime start, DateTime end, String title, String description) async {
    final url = Uri.encodeFull(
      'https://calendar.google.com/calendar/render?action=TEMPLATE'
          '&text=$title'
          '&details=$description'
          '&dates=${start.toUtc().toIso8601String().replaceAll("-", "").replaceAll(":", "").split(".")[0]}Z'
          '/${end.toUtc().toIso8601String().replaceAll("-", "").replaceAll(":", "").split(".")[0]}Z',
    );

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: "Could not open Google Calendar");
    }
  }

  void _confirmBooking(String paymentMethod) async {
    if (globalServiceCartItems.isEmpty) {
      Fluttertoast.showToast(msg: "Please select at least one service");
      return;
    }
    if (selectedDate == null || selectedTime == null) {
      Fluttertoast.showToast(msg: "Please select both date and time");
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final dayKey = "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";
    final counterRef = firestore.collection("counters").doc(dayKey);
    int newBookingNumber = 1;

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        transaction.set(counterRef, {"count": 1});
        newBookingNumber = 1;
      } else {
        final currentCount = snapshot["count"] as int;
        newBookingNumber = currentCount + 1;
        transaction.update(counterRef, {"count": newBookingNumber});
      }
    });

    final bookingDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final booking = BookingModel(
      bookingid: "",
      date: bookingDateTime,
      time: selectedTime!,
      services: selectedServices,
      bookingNumber: newBookingNumber,
      totalPrice: totalPrice,
      PaymentMethod: paymentMethod,
      userId: userId,
    );

    context.read<BookingCubit>().addBooking(booking, userId);

    Fluttertoast.showToast(
      msg: "Booking Confirmed #$newBookingNumber - ${totalPrice.toStringAsFixed(2)} EGP",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    await _addToGoogleCalendar(
      bookingDateTime,
      bookingDateTime.add(const Duration(hours: 1)),
      "Barber Appointment",
      "Services: ${selectedServices.join(", ")} | Price: ${totalPrice.toStringAsFixed(2)} EGP",
    );
  }

  void _showPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PaymentMethodSheet(
        onCash: () => _confirmBooking("Cash"),
        onCard: () {
          pay();
          _confirmBooking("Credit Card");
        },
      ),
    );
  }

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
                                  builder: (_) => const BookingHistoryView()),
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
                        onTap: _pickDate,
                      ),

                      const SizedBox(height: 20),

                      // Time Picker
                      TimePickerField(
                        selectedTime: selectedTime,
                        onTap: _pickTime,
                      ),

                      const SizedBox(height: 30),

                      // Confirm
                      ConfirmBookingButton(onPressed: _showPaymentMethodSheet),
                    ],
                  ),
                ),
              ),

              if (state is BookingLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.accentyellow),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
