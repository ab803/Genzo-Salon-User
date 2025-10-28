import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/Home/Manager/product_cubit.dart';
import 'package:userbarber/Feature/Home/Manager/product_state.dart';
import 'package:userbarber/Feature/Home/Widgets/ProductContianer.dart';
import 'package:userbarber/core/Styles/Styles.dart';

class ProductGridView extends StatelessWidget {
  final String selectedCategory;

  const ProductGridView({super.key, required this.selectedCategory});

  static const Map<String, String> categoryMap = {
    "categoryAll": "All",
    "categoryMask": "Mask",
    "categoryCream": "Cream",
    "categoryCutMachine": "Cut Machine",
    "categoryOther": "Other",
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ProductCubit is provided from parent (HomeView) via BlocProvider.value
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentyellow),
          );
        } else if (state is ProductLoaded) {
          var products = state.products;

          if (selectedCategory != "categoryAll") {
            final categoryValue =
                categoryMap[selectedCategory] ?? selectedCategory;
            products = products
                .where((p) => p.productCategory == categoryValue)
                .toList();
          }

          if (products.isEmpty) {
            return Center(
              child: Text(
                'noProducts'.getString(context),
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.primaryNavy,
                  fontSize: 16,
                ),
              ),
            );
          }

          // GridView handles its own scrolling; it's inside an Expanded in parent.
          return GridView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.all(8),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
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
        } else if (state is ProductError) {
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

        return const SizedBox.shrink();
      },
    );
  }
}
