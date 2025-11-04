import 'package:flutter/material.dart';

Future<DateTime?> pickBookingDate(BuildContext context, DateTime? selectedDate) async {
  final now = DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? now,
    firstDate: now,
    lastDate: now.add(const Duration(days: 30)),
  );
  return date;
}
