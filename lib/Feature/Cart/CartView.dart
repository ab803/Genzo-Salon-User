import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_cubit.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_state.dart';
import 'package:userbarber/Feature/Cart/widgets/CartItemContianer.dart';
import 'package:userbarber/Feature/Home/Widgets/ScaffoldWithNav.dart';
import 'package:userbarber/core/Models/OrderItem.dart';
import 'package:userbarber/core/Models/OrderModel.dart';
import 'package:userbarber/core/Services/PaymobManager/Constants.dart';
import 'package:userbarber/core/Services/PaymobManager/PatmobManager.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Utilities/cart_data.dart';
import 'package:userbarber/core/Utilities/getit.dart';
import 'package:flutter_localization/flutter_localization.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  double get total {
    return globalCartItems.fold(
      0,
      (sum, item) => sum + (item.product.productPrice * item.quantity),
    );
  }

  Future<void> pay() async {
    try {
      String paymentKey = await PaymobManager().getPaymentKey(
        total.toInt(),
        "EGP",
      );
      final url =
          "https://accept.paymob.com/api/acceptance/iframes/${Constants.iframeId}?payment_token=$paymentKey";
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print("❌ Payment failed: $e");
    }
  }

  void _showPaymentMethodSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Payment Method".getString(context),
                style: AppTextStyles.heading(
                  isDark ? AppColors.accentyellow : AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 20),

              // Cash Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentyellow,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    final userId = FirebaseAuth.instance.currentUser!.uid;
                    final order = OrderModel(
                      userId: userId,
                      orderID: DateTime.now().millisecondsSinceEpoch.toString(),
                      totalPrice: total,
                      orderDate: DateTime.now().toString(),
                      orderNumber: 0,
                      items: List.from(globalCartItems),
                      status: 'pending',
                      paymentMethod: 'cash'.getString(this.context),
                    );

                    // ✅ Use parent context
                    this.context.read<OrderCubit>().addOrder(order, userId);
                  },
                  child: Text("cash".getString(context)),
                ),
              ),
              const SizedBox(height: 12),

              // Card Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.darkBackground
                        : AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    final userId = FirebaseAuth.instance.currentUser!.uid;
                    final order = OrderModel(
                      userId: userId,
                      orderID: DateTime.now().millisecondsSinceEpoch.toString(),
                      totalPrice: total,
                      orderDate: DateTime.now().toString(),
                      orderNumber: 0,
                      items: List.from(globalCartItems),
                      status: 'pending',
                      paymentMethod: 'Credit Card'.getString(this.context),
                    );

                    // ✅ Use parent context
                    this.context.read<OrderCubit>().addOrder(order, userId);
                    await pay();
                  },
                  child: Text("Credit Card".getString(context)),
                ),
              ),
            ],
          ),
        );
      },
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
              AppBar(
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
                  onPressed: () {
                    context.go("/orderHistory");
                  },
                  icon: Icon(
                    Icons.history,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
              Expanded(
                child: globalCartItems.isEmpty
                    ? Center(
                        child: Text(
                          "cartEmpty".getString(context),
                          style: AppTextStyles.subheading(
                            isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).size.height *
                              0.15, // ✅ prevent overlap with checkout section
                        ),
                        itemCount: globalCartItems.length,
                        itemBuilder: (context, index) {
                          return CartItemContainer(
                            item: globalCartItems[index],
                            onQuantityChanged: (newQuantity) {
                              setState(() {
                                globalCartItems[index] = OrderItem(
                                  product: globalCartItems[index].product,
                                  quantity: newQuantity,
                                );
                              });
                            },
                            onRemove: () {
                              setState(() {
                                globalCartItems.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCard
                            : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "total".getString(context),
                            style: AppTextStyles.subheading(
                              isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                          Text(
                            "${"EGP".getString(context)} ${total.toStringAsFixed(2)}",
                            style: AppTextStyles.subheading(
                              AppColors.accentyellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: BlocConsumer<OrderCubit, OrderState>(
                        listener: (context, state) {
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
                          if (state is OrderLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.accentyellow,
                              ),
                            );
                          }

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentyellow,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: globalCartItems.isEmpty
                                ? null
                                : () {
                                    _showPaymentMethodSheet();
                                  },
                            child: Text(
                              "checkout".getString(context),
                              style: AppTextStyles.subheading(
                                isDark
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                              ),
                            ),
                          );
                        },
                      ),
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
