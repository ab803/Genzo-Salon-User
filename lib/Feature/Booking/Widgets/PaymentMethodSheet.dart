import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class PaymentMethodSheet extends StatelessWidget {
  final VoidCallback onCash;
  final VoidCallback onCard;

  const PaymentMethodSheet({super.key, required this.onCash, required this.onCard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Select Payment Method", style: AppTextStyles.heading(AppColors.primaryNavy)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onCash,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentyellow),
            child: const Text("Cash"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onCard,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
            child: const Text("Credit Card"),
          ),
        ],
      ),
    );
  }
}
