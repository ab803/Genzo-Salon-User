import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_cubit.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_state.dart';
import 'package:userbarber/Feature/Cart/widgets/OrderHistoryCard.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:flutter_localization/flutter_localization.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'orderHistory'.getString(context),
          style: AppTextStyles.heading(
            isDark ? AppColors.accentyellow : AppColors.primaryNavy,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        leading: IconButton(
          onPressed: () {
            context.go("/cart");
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            onPressed: () {
              final userId = FirebaseAuth.instance.currentUser!.uid;
              context.read<OrderCubit>().loadOrders(userId);
            },
          ),
        ],
        elevation: 0,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentyellow),
            );
          } else if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return Center(
                child: Text(
                  'noOrdersFound'.getString(context),
                  style: AppTextStyles.subheading(
                    isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.primaryNavy,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];

                return GestureDetector(
                  onTap: () {
                    context.push("/orderDetails", extra: order);
                  },
                  child: OrderHistoryCard(order: order),
                );
              },
            );
          } else if (state is OrderError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: isDark ? Colors.red[300] : Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
