import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userbarber/Feature/Details/Details.dart';
import 'package:userbarber/core/Models/OrderItem.dart';
import 'package:userbarber/core/Models/ProductModel.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Utilities/cart_data.dart';

/// A widget that displays a product card with its image, title, subtitle, price,
/// and an "Add to Cart" button. When tapped, it opens the product details screen.
class ProductContainer extends StatelessWidget {
  // Product info (passed from parent widget)
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

  /// Adds the current product to the global shopping cart.
  /// If it already exists, increments its quantity instead.
  void addToCart(BuildContext context) {
    // Check if this product is already in the cart
    final index = globalCartItems.indexWhere(
          (item) => item.product.productName == title,
    );

    if (index != -1) {
      // Product already in cart → increase quantity
      globalCartItems[index].quantity += 1;
    } else {
      // Product not in cart → create a new OrderItem
      globalCartItems.add(
        OrderItem(
          product: ProductModel(
            productID: '', // Empty since not stored in DB yet
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

    // Show localized toast notification
    Fluttertoast.showToast(
      msg: "addedToCart".getString(context), // localized text key
      textColor: Colors.white,
      backgroundColor: AppColors.accentyellow,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Detect current theme (for dark mode styles)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      // Navigate to Product Details screen when the whole card is tapped
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
          // If product is "not available", make the card red
          color: status == "notAvailable".getString(context)
              ? Colors.red
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image (takes flexible height in grid layouts)
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.contain, // Keeps full product visible
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Product title (main heading)
            Text(
              title,
              style: AppTextStyles.subheading(
                isDark ? Colors.white : AppColors.lightText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Product subtitle (e.g., category or brand)
            Text(
              subtitle,
              style: AppTextStyles.caption(
                isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            // Row: price (left) + add-to-cart button (right)
            Row(
              children: [
                // Product price text with localized currency
                Text(
                  "${price} " + "EGP".getString(context),
                  style: AppTextStyles.button(AppColors.accentyellow),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Add-to-cart button
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
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.lightText,
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
