import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class ConfirmBookingButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ConfirmBookingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentyellow,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text("Confirm Booking", style: AppTextStyles.subheading(Colors.white)),
      ),
    );
  }
}
