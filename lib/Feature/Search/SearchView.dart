import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<Map<String, dynamic>> allList = [];
  List<Map<String, dynamic>> resultList = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> getProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('productName')
          .get();

      setState(() {
        // Removed unnecessary cast: e.data() already returns Map<String, dynamic> for QueryDocumentSnapshot<Map<String, dynamic>>
        allList = data.docs.map((e) => e.data()).toList();
        resultList = List.from(allList); // Show all products initially
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onSearchChanged() {
    searchResultList();
  }

  void searchResultList() {
    final query = searchController.text.trim().toLowerCase();
    List<Map<String, dynamic>> showResults = [];
    if (query.isNotEmpty) {
      for (var productSnapshot in allList) {
        final title = (productSnapshot['productName'] ?? '').toString().toLowerCase();
        if (title.contains(query)) {
          showResults.add(productSnapshot);
        }
      }
    } else {
      showResults = List.from(allList);
    }

    setState(() {
      resultList = showResults;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        title: CupertinoSearchTextField(
          controller: searchController,
          placeholder: 'searchHint'.getString(context),
          placeholderStyle: AppTextStyles.caption(
            isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
          style: AppTextStyles.body(
            isDark ? AppColors.darkText : AppColors.lightText,
          ),
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          prefixIcon: const Icon(Icons.search),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: AppTextStyles.subheading(
            isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
      )
          : resultList.isEmpty
          ? Center(
        child: Text(
          'noResults'.getString(context),
          style: AppTextStyles.subheading(
            isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
          ),
        ),
      )
          : ListView.builder(
        itemCount: resultList.length,
        itemBuilder: (context, index) {
          final product = resultList[index];

          // Safe null handling and type conversions
          final name = product['productName']?.toString() ?? "Unnamed product";
          final description = product['ProductCategory']?.toString() ?? "No description";
          final id = product['id']?.toString() ?? "";
          final priceValue = product['productPrice'];

          double? priceNum;
          if (priceValue is num) {
            priceNum = priceValue.toDouble();
          } else if (priceValue is String) {
            priceNum = double.tryParse(priceValue);
          }

          final price = priceNum != null ? priceNum.toStringAsFixed(2) : "0.00";

          return ListTile(
            title: Text(
              name,
              style: AppTextStyles.subheading(
                isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            subtitle: Text(
              description,
              style: AppTextStyles.body(
                isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
              ),
            ),
            trailing: Text(
              "currencyEGP".getString(context).replaceFirst("{price}", price),
              style: AppTextStyles.subheading(AppColors.accentyellow),
            ),
            onTap: () {
              if (id.isNotEmpty) {
                context.go('/product/$id');
              }
            },
          );
        },
      ),
    );
  }
}