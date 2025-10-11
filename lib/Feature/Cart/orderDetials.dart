import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_cubit.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_state.dart';
import 'package:userbarber/core/Models/OrderModel.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:flutter_localization/flutter_localization.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? AppColors.darkText : AppColors.lightText),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "${'order'.getString(context)} ${order.orderNumber}",
          style: AppTextStyles.heading(isDark ? AppColors.darkText : AppColors.lightText),
        ),
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            Fluttertoast.showToast(
              backgroundColor: Colors.green,
              textColor: AppColors.primaryNavy,
              msg: 'orderCanceledSuccessfully'.getString(context),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
            );
            context.pop();
          } else if (state is OrderError) {
            Fluttertoast.showToast(
              backgroundColor: Colors.red,
              textColor: AppColors.primaryNavy,
              msg: 'errorCancelingOrder'.getString(context),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentyellow),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${'orderID'.getString(context)}: ${order.orderID}",
                    style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 8),
                Text("${'status'.getString(context)}: ${order.status}",
                    style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 8),
                Text("${'totalPrice'.getString(context)}: ${order.totalPrice} ${'EGP'.getString(context)}",
                    style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 8),
                Text("${'date'.getString(context)}: ${order.orderDate}",
                    style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 16),
                Text('${'paymentMethod'.getString(context)} : ${order.paymentMethod.getString(context)}',
                    style: AppTextStyles.body(isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText)),
                Text('items'.getString(context),
                    style: AppTextStyles.subheading(isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 10),


                Expanded(
                  child: ListView.builder(
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return Card(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Image.network(
                            item.product.imgUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item.product.productName,
                              style: AppTextStyles.body(AppColors.accentyellow)),
                          subtitle: Text("${'quantity'.getString(context)}: ${item.quantity}",
                              style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText)),
                          trailing: Text("${item.product.productPrice} ${'EGP'.getString(context)}",
                              style: AppTextStyles.body(isDark ? AppColors.darkText : AppColors.lightText)),
                        ),
                      );
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        final userId = order.userId;
                        context.read<OrderCubit>().updateOrderStatus(order.orderID, "canceled", userId);
                      },
                      icon: Icon(Icons.cancel, color: isDark ? AppColors.darkText : AppColors.lightText),
                      label: Text('cancel'.getString(context),
                          style: AppTextStyles.button(isDark ? AppColors.darkText : AppColors.lightText)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
