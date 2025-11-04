import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__cubit.dart';
import 'package:userbarber/core/Models/bookingModel.dart';
import 'package:userbarber/core/Utilities/serviceList.dart';

Future<void> confirmBooking({
  required BuildContext context,
  required String paymentMethod,
  required DateTime selectedDate,
  required TimeOfDay selectedTime,
}) async {
  final firestore = FirebaseFirestore.instance;

  final dayKey = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
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
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final totalPrice = globalServiceCartItems.fold(0.0, (sum, s) => sum + s.price);
  final selectedServices = globalServiceCartItems.map((s) => s.name).toList();

  final booking = BookingModel(
    bookingid: "",
    date: bookingDateTime,
    time: selectedTime,
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
}
