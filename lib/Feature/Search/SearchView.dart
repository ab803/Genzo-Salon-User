import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Search/widgets/ProductTile.dart';
import 'package:userbarber/Feature/Search/widgets/SearchUtilies.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

/// Stateful widget for the search screen where users can search
/// products fetched from Firestore in real-time (local filtering).
class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // Stores all products fetched from Firestore
  List<Map<String, dynamic>> allList = [];

  // Stores filtered results based on user search query
  List<Map<String, dynamic>> resultList = [];

  // Controller for the search input field
  final TextEditingController searchController = TextEditingController();

  // Flags for loading and error states
  bool isLoading = false;
  String? errorMessage;

  /// Fetches all products from the "products" collection in Firestore,
  /// ordered by product name alphabetically.
  Future<void> getProducts() async {
    try {
      // Set loading state before starting the request
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Retrieve data from Firestore
      final QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('products')
          .orderBy('productName')
          .get();

      // Store all fetched products and show them initially
      setState(() {
        allList = data.docs.map((e) => e.data()).toList();
        resultList = List.from(allList);
      });
    } catch (e) {
      // Handle any error during fetching
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      // Stop loading spinner after completion
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Called whenever the text in the search field changes.
  /// Filters the product list using `filterProducts` from utilities.
  void onSearchChanged() {
    final query = searchController.text;
    setState(() {
      resultList = filterProducts(allList, query);
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts(); // Fetch product data when view is initialized
    searchController.addListener(onSearchChanged); // Start listening for text input
  }

  @override
  void dispose() {
    // Clean up listeners and controller to prevent memory leaks
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detect if app is in dark mode to adjust colors dynamically
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Background adapts to current theme
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,

      // App bar with search input field
      appBar: AppBar(
        backgroundColor:
        isDark ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,

        // Back button navigates to home
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),

        // Cupertino-style search bar with localization
        title: CupertinoSearchTextField(
          controller: searchController,
          placeholder: 'searchHint'.getString(context), // Localized hint
          placeholderStyle: AppTextStyles.caption(
            isDark
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
          style: AppTextStyles.body(
            isDark ? AppColors.darkText : AppColors.lightText,
          ),
          backgroundColor:
          isDark ? AppColors.darkCard : AppColors.lightCard,
          prefixIcon: const Icon(Icons.search),
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Body content based on loading/error/search state
      body: isLoading
      // Loading spinner while fetching data
          ? const Center(child: CircularProgressIndicator())

      // Display error message if Firestore request fails
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: AppTextStyles.subheading(
            isDark
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
        ),
      )

      // Show “no results” if search yields no matches
          : resultList.isEmpty
          ? Center(
        child: Text(
          'noResults'.getString(context), // Localized text
          style: AppTextStyles.subheading(
            isDark
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
        ),
      )

      // Otherwise, display product search results in a ListView
          : ListView.builder(
        itemCount: resultList.length,
        itemBuilder: (context, index) {
          final product = resultList[index];

          // Each product displayed using ProductTile widget
          return ProductTile(
            product: product,
            isDark: isDark,
            onTap: (id) {
              // Navigate to product detail page using product ID
              if (id.isNotEmpty) context.go('/product/$id');
            },
          );
        },
      ),
    );
  }
}
