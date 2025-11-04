import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_cubit.dart';
import 'package:userbarber/Feature/Cart/widgets/CartAppBar.dart';
import 'package:userbarber/Feature/Cart/widgets/CartListView.dart';
import 'package:userbarber/Feature/Cart/widgets/CartTotalSection.dart';
import 'package:userbarber/Feature/Cart/widgets/CheckoutButton.dart';
import 'package:userbarber/Feature/Home/Widgets/ScaffoldWithNav.dart';
import 'package:userbarber/Feature/PaymentWidgets/PaymentSheetForOrders.dart';
import 'package:userbarber/core/Models/OrderItem.dart';
import 'package:userbarber/core/Utilities/cart_data.dart';
import 'package:userbarber/core/Utilities/getit.dart';

/// ✅ CartView: Displays cart items, total, and handles checkout & payment.
class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  /// 🔹 Calculate total price
  double get total {
    return globalCartItems.fold(
      0,
          (sum, item) => sum + (item.product.productPrice * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaffoldWithNav(
      selectedIndex: 2,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: BlocProvider<OrderCubit>(
          create: (context) => getIt<OrderCubit>(),
          child: Column(
            children: [
              CartAppBar(isDark: isDark),

              /// 🔹 Cart items
              Expanded(
                child: CartListView(
                  isDark: isDark,
                  onQuantityChanged: (index, newQuantity) {
                    setState(() {
                      globalCartItems[index] = OrderItem(
                        product: globalCartItems[index].product,
                        quantity: newQuantity,
                      );
                    });
                  },
                  onRemove: (index) {
                    setState(() {
                      globalCartItems.removeAt(index);
                    });
                  },
                ),
              ),

              /// 🔹 Total + Checkout
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CartTotalSection(isDark: isDark, total: total),
                    const SizedBox(height: 20),
                    CheckoutButton(
                      isDark: isDark,
                      onCheckout: () => showPaymentMethodSheetForOrders(context, total),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
