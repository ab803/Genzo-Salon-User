import 'package:flutter/material.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class ServiceSelectButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ServiceSelectButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentyellow,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 20,color: AppColors.primaryNavy,),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTextStyles.button(AppColors.primaryNavy),
          ),
        ],
      ),
    );
  }
}
