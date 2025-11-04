import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_cubit.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_state.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Utilities/cart_data.dart';

/// 🔹 Checkout button that listens to OrderCubit states
class CheckoutButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onCheckout;

  const CheckoutButton({
    super.key,
    required this.isDark,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          // ✅ Show success or error toast
          if (state is OrderSuccess) {
            Fluttertoast.showToast(
              msg: "orderSuccess".getString(context),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else if (state is OrderError) {
            Fluttertoast.showToast(
              msg: "orderError".getString(context),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        builder: (context, state) {
          // 🔄 Loading indicator while adding order
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentyellow),
            );
          }

          // ✅ Checkout button
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentyellow,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed:
            globalCartItems.isEmpty ? null : () => onCheckout.call(),
            child: Text(
              "checkout".getString(context),
              style: AppTextStyles.subheading(
                isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          );
        },
      ),
    );
  }
}
