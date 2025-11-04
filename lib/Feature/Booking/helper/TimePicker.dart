import 'package:flutter/material.dart';

Future<TimeOfDay?> pickBookingTime(BuildContext context) async {
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  return time;
}
