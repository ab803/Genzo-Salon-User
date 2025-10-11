import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userbarber/Feature/Home/helper.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ProductDetailsView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final double price;
  final String imgUrl;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,
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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.accentyellow),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                imgUrl,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  title,
                  style: AppTextStyles.subheading(
                      isDark ? AppColors.darkText : AppColors.lightText),
                ),
                const Spacer(),
                Text(
                  subtitle,
                  style: AppTextStyles.caption(isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.lightSecondaryText),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "${'description'.getString(context)}:",
              style: AppTextStyles.subheading(
                  isDark ? AppColors.darkText : AppColors.lightText),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: AppTextStyles.caption(
                  isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  "${'price'.getString(context)}: ${price.toStringAsFixed(2)} ${'egp'.getString(context)}",
                  style: AppTextStyles.button(
                      isDark ? AppColors.darkText : AppColors.lightText),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentyellow,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {
                    product().addItemfromProduct(title, price, imgUrl);
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
                        isDark ? AppColors.darkText : AppColors.lightText),
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
