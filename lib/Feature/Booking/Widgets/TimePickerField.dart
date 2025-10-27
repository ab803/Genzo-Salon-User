import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class TimePickerField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final VoidCallback onTap;

  const TimePickerField({super.key, required this.selectedTime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                  : "Select a Time",
              style: AppTextStyles.body(AppColors.primaryNavy),
            ),
            const Icon(Icons.access_time, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
