import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

/// 🔹 AppBar with cart title and order history button
class CartAppBar extends StatelessWidget {
  final bool isDark;
  const CartAppBar({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "myCart".getString(context),
        style: AppTextStyles.heading(
          isDark ? AppColors.darkText : AppColors.lightText,
        ),
      ),
      leading: IconButton(
        onPressed: () => context.go("/orderHistory"),
        icon: Icon(
          Icons.history,
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
      ),
    );
  }
}
