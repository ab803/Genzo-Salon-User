import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class CustomHashText extends StatelessWidget {
  final bool isDark;
  final String prefixText;
  final String actionText;
  final String route;

  const CustomHashText({
    super.key,
    required this.isDark,
    required this.prefixText,
    required this.actionText,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(route),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            prefixText,
            style: AppTextStyles.caption(
              isDark
                  ? AppColors.darkSecondaryText
                  : AppColors.lightSecondaryText,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            actionText,
            style: AppTextStyles.caption(AppColors.accentyellow),
          ),
        ],
      ),
    );
  }
}
