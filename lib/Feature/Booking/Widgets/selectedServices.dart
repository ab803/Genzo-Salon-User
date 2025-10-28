import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:userbarber/core/Utilities/serviceList.dart'; // where globalServiceCartItems is stored

class SelectedServicesList extends StatefulWidget {
  const SelectedServicesList({super.key});

  @override
  State<SelectedServicesList> createState() => _SelectedServicesListState();
}

class _SelectedServicesListState extends State<SelectedServicesList> {
  double get totalPrice {
    return globalServiceCartItems.fold(
      0.0,
      (sum, service) => sum + service.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        centerTitle: true,
        title: Text(
          "selectedServices".getString(context), // ✅ localized
          style: AppTextStyles.heading(
            isDark ? AppColors.darkText : AppColors.primaryNavy,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.go("/booking");
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? AppColors.darkText : AppColors.primaryNavy,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: globalServiceCartItems.isEmpty
                ? Center(
                    child: Text(
                      "noServices".getString(
                        context,
                      ), // ✅ localized empty state
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.primaryNavy,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: globalServiceCartItems.length,
                    itemBuilder: (context, index) {
                      final service = globalServiceCartItems[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                service.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.primaryNavy,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${service.price.toStringAsFixed(2)} ${"currency".getString(context)}", // ✅ localized currency
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? AppColors.darkText
                                        : AppColors.primaryNavy,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      globalServiceCartItems.removeAt(
                                        index,
                                      ); // ✅ remove safely
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Total section at bottom
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "total".getString(context), // ✅ localized
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.primaryNavy,
                  ),
                ),
                Text(
                  "${totalPrice.toStringAsFixed(2)} ${"currency".getString(context)}", // ✅ localized currency
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.primaryNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
