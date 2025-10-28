import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userbarber/Feature/Home/Widgets/ProductGridView.dart';
import 'package:userbarber/Feature/Home/Widgets/ProductListItem.dart';
import 'package:userbarber/Feature/Home/Widgets/ScaffoldWithNav.dart';
import 'package:userbarber/Feature/Home/Widgets/header.dart';
import 'package:userbarber/Feature/Home/Manager/product_cubit.dart';
import 'package:userbarber/Feature/Home/productRepo/productRepo.dart';
import 'package:userbarber/core/Services/Firestore.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;

  // create cubit once and reuse
  late final ProductCubit _productCubit;

  final List<String> categoryKeys = [
    'categoryAll',
    'categoryMask',
    'categoryCream',
    'categoryCutMachine',
    'categoryOther',
  ];

  @override
  void initState() {
    super.initState();
    _productCubit = ProductCubit(ProductRepository(FirestoreService()));
    _productCubit.listenToProducts(); // start listening once
  }

  @override
  void dispose() {
    _productCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return ScaffoldWithNav(
      selectedIndex: 0,
      // Provide the cubit once to descendant widgets so it is not recreated every rebuild
      child: BlocProvider.value(
        value: _productCubit,
        child: Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              SizedBox(height: screenHeight * 0.02),

              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.04),
                child: Text(
                  'products'.getString(context),
                  style: AppTextStyles.subheading(
                    textColor ?? AppColors.primaryNavy,
                  ).copyWith(fontSize: screenWidth * 0.05),
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              SizedBox(
                height: screenHeight * 0.06,
                child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.03),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryKeys.length,
                    itemBuilder: (context, index) {
                      final categoryKey = categoryKeys[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.015,
                        ),
                        child: ProductListItem(
                          categoryKey: categoryKey,
                          isSelected: index == selectedIndex,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // Let the grid expand and handle its own scrolling (avoid nested scrollviews)
              Expanded(
                child: ProductGridView(
                  selectedCategory: categoryKeys[selectedIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
