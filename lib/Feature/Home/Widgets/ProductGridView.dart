import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/Home/Manager/product_cubit.dart';
import 'package:userbarber/Feature/Home/Manager/product_state.dart';
import 'package:userbarber/Feature/Home/Widgets/ProductContianer.dart';
import 'package:userbarber/core/Styles/Styles.dart';

/// A widget that displays a grid of products fetched using [ProductCubit].
/// It automatically filters the products based on the selected category.
class ProductGridView extends StatelessWidget {
  /// The currently selected category (localized key name, e.g., "categoryCream").
  final String selectedCategory;

  const ProductGridView({super.key, required this.selectedCategory});

  /// A map connecting localized category keys to their actual string values in data.
  /// Example: when "categoryCream" is selected, we compare against "Cream".
  static const Map<String, String> categoryMap = {
    "categoryAll": "All",
    "categoryMask": "Mask",
    "categoryCream": "Cream",
    "categoryCutMachine": "Cut Machine",
    "categoryOther": "Other",
  };

  @override
  Widget build(BuildContext context) {
    // Detect current theme (dark or light) to adjust text colors
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ProductCubit is already provided higher up (in HomeView)
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        // ⏳ State 1: Still loading product data
        if (state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentyellow),
          );
        }

        // ✅ State 2: Successfully loaded products
        else if (state is ProductLoaded) {
          var products = state.products;

          // Filter by selected category (skip filtering if "All" is selected)
          if (selectedCategory != "categoryAll") {
            final categoryValue =
                categoryMap[selectedCategory] ?? selectedCategory;
            products = products
                .where((p) => p.productCategory == categoryValue)
                .toList();
          }

          // 🪫 If no products match the category
          if (products.isEmpty) {
            return Center(
              child: Text(
                'noProducts'.getString(context), // localized "No products" text
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.primaryNavy,
                  fontSize: 16,
                ),
              ),
            );
          }

          // 🧱 Build the product grid layout
          return GridView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.all(8),
            physics: const BouncingScrollPhysics(), // Smooth iOS-like scrolling
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              // Defines the layout of grid items
              maxCrossAxisExtent: 220, // max width per grid tile
              crossAxisSpacing: 10, // horizontal spacing
              mainAxisSpacing: 10, // vertical spacing
              childAspectRatio: 0.75, // tile height ratio
            ),

            // Each grid tile is a [ProductContainer]
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductContainer(
                description: product.productDescription,
                title: product.productName,
                subtitle: product.productCategory,
                price: product.productPrice,
                imgUrl: product.imgUrl,
                status: product.productStatus,
              );
            },
          );
        }

        // ❌ State 3: Error while loading products
        else if (state is ProductError) {
          return Center(
            child: Text(
              '${'errorOccurred'.getString(context)}: ${state.message}',
              style: TextStyle(
                color: isDark ? AppColors.accentyellow : Colors.red,
                fontSize: 16,
              ),
            ),
          );
        }

        // Empty fallback widget (used when state is initial or unhandled)
        return const SizedBox.shrink();
      },
    );
  }
}
