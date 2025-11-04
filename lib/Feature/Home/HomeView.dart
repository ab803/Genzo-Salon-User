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
  late final ProductCubit _productCubit;
  // categories
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
    _productCubit.listenToProducts();
  }

  @override
  void dispose() {
    _productCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ScaffoldWithNav(
      selectedIndex: 0,
      child: BlocProvider.value(
        value: _productCubit,
        child: LayoutBuilder(
          // responsive design
          builder: (context, constraints) {
            final isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;
            final screenWidth = constraints.maxWidth;
            final textColor = Theme.of(context).textTheme.bodyLarge?.color;
            // to be scrollable
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Header(),
                    SizedBox(height: screenWidth * 0.04),

                    // Products title
                    Text(
                      'products'.getString(context),
                      style: AppTextStyles.subheading(
                        textColor ?? AppColors.primaryNavy,
                      ).copyWith(fontSize: screenWidth * 0.05),
                    ),
                    SizedBox(height: screenWidth * 0.03),

                    // Categories scroll
                    SizedBox(
                      height: 50,
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
                                setState(() => selectedIndex = index);
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.04),

                    // Products grid
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 300,
                        maxHeight: isLandscape
                            ? constraints.maxHeight * 1.5
                            : constraints.maxHeight * 1.2,
                      ),
                      child: ProductGridView(
                        // to filter category of products
                        selectedCategory: categoryKeys[selectedIndex],
                      ),
                    ),
                  ],
                ),

            );
          },
        ),
      ),
    );
  }
}
