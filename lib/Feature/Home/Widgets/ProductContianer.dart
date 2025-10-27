import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userbarber/Feature/Details/Details.dart';
import 'package:userbarber/core/Models/OrderItem.dart';
import 'package:userbarber/core/Models/ProductModel.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Utilities/cart_data.dart';
import 'package:userbarber/Feature/Localization/Locales.dart';

class ProductContainer extends StatelessWidget {
  final String imgUrl, title, subtitle, description, status;
  final double price;

  const ProductContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imgUrl,
    required this.status,
    required this.description,
  });

  void addToCart(BuildContext context) {
    final index = globalCartItems.indexWhere(
          (item) => item.product.productName == title,
    );

    if (index != -1) {
      globalCartItems[index].quantity += 1;
    } else {
      globalCartItems.add(
        OrderItem(
          product: ProductModel(
            productID: '',
            productName: title,
            productDescription: '',
            imgUrl: imgUrl,
            productPrice: price,
            productStatus: 'pending',
            productCategory: '',
          ),
          quantity: 1,
        ),
      );
    }

    Fluttertoast.showToast(
      msg: "addedToCart".getString(context),
      textColor: Colors.white,
      backgroundColor: AppColors.accentyellow,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // format price safely
    final priceStr = price.toStringAsFixed(2);
    final priceText = 'priceWithCurrency'.getString(context).replaceAll('{price}', priceStr);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsView(
              title: title,
              subtitle: subtitle,
              description: description,
              price: price,
              imgUrl: imgUrl,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: status == "notAvailable".getString(context)
              ? Colors.red
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // use Flexible instead of Expanded to make the tile layout more predictable
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.subheading(
                  isDark ? Colors.white : AppColors.lightText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.caption(
                  isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Flexible(
                  child: Text(
                    priceText,
                    style: AppTextStyles.button(AppColors.accentyellow),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => addToCart(context),
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.accentyellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}