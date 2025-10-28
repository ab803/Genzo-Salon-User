import 'package:flutter/cupertino.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class CustomHeaderText extends StatelessWidget {
  final bool isDark;
  final String title;
  const CustomHeaderText({required this.isDark, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.subheading(
        isDark ? AppColors.darkText : AppColors.lightText,
      ),
      textAlign: TextAlign.center,
    );
  }
}
