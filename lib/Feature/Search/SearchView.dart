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
  List allList = [];
  List resultList = [];
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
        allList = data.docs.map((e) => e.data() as Map<String, dynamic>).toList();
        resultList = List.from(allList); // ✅ Show all products initially
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
    var showResults = [];
    if (searchController.text.isNotEmpty) {
      for (var productSnapshot in allList) {
        var title = productSnapshot['productName'].toString().toLowerCase();
        if (title.contains(searchController.text.toLowerCase())) {
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
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor:
        isDark ? AppColors.darkBackground : AppColors.lightBackground,
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
              isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
          style: AppTextStyles.body(
              isDark ? AppColors.darkText : AppColors.lightText),
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
            isDark
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
        ),
      )
          : resultList.isEmpty
          ? Center(
        child: Text(
          'noResults'.getString(context),
          style: AppTextStyles.subheading(
            isDark
                ? AppColors.darkSecondaryText
                : AppColors.lightSecondaryText,
          ),
        ),
      )
          : ListView.builder(
        itemCount: resultList.length,
        itemBuilder: (context, index) {
          final product = resultList[index];

          // ✅ Safe null handling
          final name = product['productName'] ?? "Unnamed product";
          final description =
              product['ProductCategory'] ?? "No description";
          final id = product['id'] ?? "";
          final priceValue = product['productPrice'];

          // Make sure price is a number
          final price = (priceValue is num)
              ? priceValue.toStringAsFixed(2)
              : "0.00";

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
                isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.lightSecondaryText,
              ),
            ),
            trailing: Text(
              "currencyEGP"
                  .getString(context)
                  .replaceFirst("{price}", price),
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
