import 'package:flutter/material.dart';

/// 🔹 Reusable button for each payment option
class PaymentButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const PaymentButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
