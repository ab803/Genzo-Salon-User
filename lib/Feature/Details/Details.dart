import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userbarber/Feature/Home/helper.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

/// This widget displays the detailed view of a selected product.
/// It shows the image, title, description, and price,
/// and allows the user to add the item to the cart.
class ProductDetailsView extends StatelessWidget {
  final String title;       // Product title
  final String subtitle;    // Optional subtitle (e.g., category or type)
  final String description; // Product description text
  final double price;       // Product price
  final String imgUrl;      // Product image URL

  const ProductDetailsView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imgUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the app is in dark mode for adaptive styling
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Change background color based on theme mode
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,

      // AppBar section
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.subheading(AppColors.accentyellow),
        ),
        centerTitle: true,
        backgroundColor:
        isDark ? AppColors.darkBackground : AppColors.lightBackground,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Go back to previous screen
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.accentyellow,
          ),
        ),
        elevation: 0, // Removes AppBar shadow for a clean look
      ),

      // Main Body Section
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (centered)
            Center(
              child: Image.network(
                imgUrl,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            // Product Title and Subtitle Row
            Row(
              children: [
                // Title text (styled based on theme)
                Text(
                  title,
                  style: AppTextStyles.subheading(
                    isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const Spacer(),

                // Subtitle text (e.g., category)
                Text(
                  subtitle,
                  style: AppTextStyles.caption(
                    isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Description Header (localized text)
            Text(
              "${'description'.getString(context)}:",
              style: AppTextStyles.subheading(
                isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),

            const SizedBox(height: 10),

            // Product Description text
            Text(
              description,
              style: AppTextStyles.caption(
                isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),

            const Spacer(),

            // Price and Add to Cart Button
            Row(
              children: [
                // Product Price with currency (localized)
                Text(
                  "${'price'.getString(context)}: ${price.toStringAsFixed(2)} ${'egp'.getString(context)}",
                  style: AppTextStyles.button(
                    isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),

                const Spacer(),

                // Add to Cart Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentyellow,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    // Add the selected product to the cart
                    product().addItemfromProduct(title, price, imgUrl);

                    // Show a confirmation toast message
                    Fluttertoast.showToast(
                      msg: 'addedToCart'.getString(context),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      backgroundColor: AppColors.accentyellow,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  child: Text(
                    'addToCart'.getString(context),
                    style: AppTextStyles.button(
                      isDark ? AppColors.darkText : AppColors.lightText,
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
