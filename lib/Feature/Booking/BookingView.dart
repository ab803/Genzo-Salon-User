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
import 'package:userbarber/Feature/Booking/Widgets/serviceButton.dart';
import 'package:userbarber/core/Services/PaymobManager/Constants.dart';
import 'package:userbarber/core/Services/PaymobManager/PatmobManager.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/Feature/Home/Widgets/ScaffoldWithNav.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__state.dart';
import 'package:userbarber/core/Models/bookingModel.dart';
import 'package:userbarber/core/Utilities/serviceList.dart';

class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  double get totalPrice {
    return globalServiceCartItems.fold(0.0, (sum, service) => sum + service.price);
  }

  List<String> get selectedServices {
    return globalServiceCartItems.map((service) => service.name).toList();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: ThemeData(
            brightness: isDark ? Brightness.dark : Brightness.light,
            colorScheme: (isDark ? const ColorScheme.dark() : const ColorScheme.light()).copyWith(
              primary: AppColors.accentyellow,
              onPrimary: isDark ? AppColors.darkText : AppColors.lightText,
              onSurface: isDark ? AppColors.lightCard : AppColors.primaryNavy,
            ),
            dialogBackgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          ),
          child: child!,
        );
      },
    );

    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: ThemeData(
            brightness: isDark ? Brightness.dark : Brightness.light,
            colorScheme: (isDark ? const ColorScheme.dark() : const ColorScheme.light()).copyWith(
              primary: AppColors.accentyellow,
              onPrimary: AppColors.primaryNavy,
              onSurface: isDark ? AppColors.lightCard : AppColors.primaryNavy,
            ),
            dialogBackgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          ),
          child: child!,
        );
      },
    );

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

  void _showPaymentMethodSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Payment Method".getString(context),
                style: AppTextStyles.heading(
                  isDark ? AppColors.accentyellow : AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 20),

              // Cash Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentyellow,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmBooking("cash".getString(context));
                  },
                  child: Text("cash".getString(context)),
                ),
              ),
              const SizedBox(height: 12),

              // Card Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isDark ? AppColors.darkBackground : AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    pay();
                    _confirmBooking("Credit Card".getString(context));
                  },
                  child: Text("Credit Card".getString(context)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ✅ Add Google Calendar Event Helper
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

  /// ✅ Confirm Booking + Add Reminder
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

    final toastMsg = context.formatString(
      'bookingConfirmed',
      [newBookingNumber.toString(), totalPrice.toStringAsFixed(2)],
    );

    Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // ✅ Add reminder to Google Calendar
    final endDateTime = bookingDateTime.add(const Duration(hours: 1));
    await _addToGoogleCalendar(
      bookingDateTime,
      endDateTime,
      "Barber Appointment",
      "Services: ${selectedServices.join(", ")} | Price: ${totalPrice.toStringAsFixed(2)} EGP",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ Screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                padding: EdgeInsets.all(screenWidth * 0.04), // ✅ dynamic padding
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.08,
                    top: screenHeight * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------- HEADER ----------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'bookAppointment'.getString(context),
                            style: AppTextStyles.heading(
                              isDark ? AppColors.darkText : AppColors.lightText,
                            ).copyWith(
                              fontSize: screenWidth * 0.055,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.history,
                              size: screenWidth * 0.06,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BookingHistoryView()),
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // ---------- SERVICE SELECT ----------
                      ServiceSelectButton(
                        title: 'selectService'.getString(context),
                        onPressed: () {
                          context.go("/services");
                        },
                      ),
                      SizedBox(height: screenHeight * 0.025),

                      ServiceSelectButton(
                        title: context.formatString(
                          'selectedServicesWithCount',
                          [
                            globalServiceCartItems.length.toString(),
                            totalPrice.toStringAsFixed(2)
                          ],
                        ),
                        onPressed: () {
                          context.go("/selected");
                        },
                      ),
                      SizedBox(height: screenHeight * 0.025),

                      // ---------- DATE PICKER ----------
                      Text(
                        "selectADate".getString(context),
                        style: AppTextStyles.subheading(AppColors.primaryNavy)
                            .copyWith(fontSize: screenWidth * 0.045),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.018,
                            horizontal: screenWidth * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightCard,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDate != null
                                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                    : "selectADate".getString(context),
                                style: AppTextStyles.body(AppColors.primaryNavy)
                                    .copyWith(fontSize: screenWidth * 0.04),
                              ),
                              Icon(Icons.calendar_today,
                                  size: screenWidth * 0.05, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // ---------- TIME PICKER ----------
                      Text(
                        "selectATime".getString(context),
                        style: AppTextStyles.subheading(AppColors.primaryNavy)
                            .copyWith(fontSize: screenWidth * 0.045),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      GestureDetector(
                        onTap: _pickTime,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.018,
                            horizontal: screenWidth * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightCard,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedTime != null
                                    ? selectedTime!.format(context)
                                    : "selectATime".getString(context),
                                style: AppTextStyles.body(AppColors.primaryNavy)
                                    .copyWith(fontSize: screenWidth * 0.04),
                              ),
                              Icon(Icons.access_time,
                                  size: screenWidth * 0.05, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),

                      // ---------- CONFIRM BUTTON ----------
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentyellow,
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: _showPaymentMethodSheet,
                          child: Text(
                            "confirmBooking".getString(context),
                            style: AppTextStyles.subheading(Colors.white)
                                .copyWith(fontSize: screenWidth * 0.045),
                          ),
                        ),
                      ),
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
