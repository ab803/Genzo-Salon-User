import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/Cart/widgets/CartItemContianer.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Utilities/cart_data.dart';

/// 🔹 Displays all items in the cart, or empty message if none exist
class CartListView extends StatelessWidget {
  final bool isDark;
  final Function(int, int) onQuantityChanged;
  final Function(int) onRemove;

  const CartListView({
    super.key,
    required this.isDark,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // Empty cart message
    if (globalCartItems.isEmpty) {
      return Center(
        child: Text(
          "cartEmpty".getString(context),
          style: AppTextStyles.subheading(
            isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      );
    }

    // Cart items list
    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.15,
      ),
      itemCount: globalCartItems.length,
      itemBuilder: (context, index) {
        return CartItemContainer(
          item: globalCartItems[index],
          onQuantityChanged: (newQuantity) =>
              onQuantityChanged(index, newQuantity),
          onRemove: () => onRemove(index),
        );
      },
    );
  }
}
