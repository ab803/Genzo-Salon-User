import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:userbarber/Feature/Home/Widgets/offersList.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect whether the current theme is dark or light
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // Adds internal spacing around all sides
      padding: const EdgeInsets.all(10),
      // Takes the full screen width
      width: double.infinity,
      // Header background styling
      decoration: BoxDecoration(
        color: AppColors.accentyellow, // Bright yellow background
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ), // Rounded bottom corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👇 Top section: welcome text + settings button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero, // Remove extra padding
              title: Text(
                "welcomeTo".getString(context), // Localized "Welcome to"
                style: AppTextStyles.heading(AppColors.primaryNavy),
              ),
              subtitle: Text(
                "genzoSalon".getString(context), // Localized "Genzo Salon"
                style: AppTextStyles.subheading(AppColors.primaryNavy),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.display_settings_rounded,
                  color: AppColors.primaryNavy, // Matches the theme color
                ),
                // Opens the end drawer (settings) when pressed
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 👇 Search bar section
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
              // The width is 88% of the screen width for spacing consistency
              width: MediaQuery.of(context).size.width * 0.88,
              child: TextField(
                // Navigates to the search screen when tapped
                onTap: () {
                  context.go('/search');
                },
                decoration: InputDecoration(
                  hintText: "searchHint".getString(context), // Localized hint text
                  prefixIcon: const Icon(Icons.search), // Search icon inside the field
                  filled: true,
                  fillColor:
                  isDark ? AppColors.darkCard : AppColors.lightCard, // Theme-based background
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 5), // Compact padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // Removes border outline
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 👇 Offer section (carousel or list of promotional cards)
          SizedBox(
            height: 190,
            child: const OfferListView(), // Custom widget displaying offer cards
          ),
        ],
      ),
    );
  }
}
