import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_cubit.dart';
import 'package:userbarber/Feature/PaymentWidgets/PaymentHelper.dart';
import 'package:userbarber/Feature/PaymentWidgets/PaymentMethodSheet.dart';
import 'package:userbarber/core/Models/OrderModel.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Utilities/cart_data.dart';


/// ✅ Reusable handler for showing the payment method sheet
void showPaymentMethodSheetForOrders(BuildContext context, double total) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
    builder: (context) {
      return PaymentMethodSheet(
        isDark: isDark,
        total: total,

        /// 💵 Cash payment
        onCash: () {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            Fluttertoast.showToast(
              msg: "Please log in to place an order.",
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            return;
          }

          final userId = FirebaseAuth.instance.currentUser!.uid;
          final order = OrderModel(
            orderID: DateTime.now().millisecondsSinceEpoch.toString(),
            orderNumber: 0,
            userId: userId,
            items: List.from(globalCartItems),
            totalPrice: total,
            paymentMethod: "Cash",
            orderDate: DateTime.now().toIso8601String(),
            status: "",
          );

          context.read<OrderCubit>().addOrder(order, userId);

          globalCartItems.clear();
          Navigator.pop(context);

          Fluttertoast.showToast(
            msg: "Order placed successfully (Cash)!",
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        },

        /// 💳 Card payment
        onCard: () async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            Fluttertoast.showToast(
              msg: "Please log in to place an order.",
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            return;
          }

          await PaymentHelper.payWithCard(total);

          final userId = FirebaseAuth.instance.currentUser!.uid;
          final order = OrderModel(
            orderID: DateTime.now().millisecondsSinceEpoch.toString(),
            orderNumber: 0,
            userId: userId,
            items: List.from(globalCartItems),
            totalPrice: total,
            paymentMethod: "Card",
            orderDate: DateTime.now().toIso8601String(),
            status: "",
          );

          context.read<OrderCubit>().addOrder(order, userId);

          globalCartItems.clear();
          Navigator.pop(context);

          Fluttertoast.showToast(
            msg: "Order placed successfully (Card)!",
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        },
      );
    },
  );
}
