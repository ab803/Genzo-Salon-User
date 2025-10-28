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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accentyellow,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "welcomeTo".getString(context), // 🔑 localized
                style: AppTextStyles.heading(AppColors.primaryNavy),
              ),
              subtitle: Text(
                "genzoSalon".getString(context), // 🔑 localized
                style: AppTextStyles.subheading(AppColors.primaryNavy),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.display_settings_rounded,
                  color: AppColors.primaryNavy,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.88,
              child: TextField(
                onTap: () {
                  context.go('/search');
                },
                decoration: InputDecoration(
                  hintText: "searchHint".getString(context), // 🔑 localized
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 190, child: const OfferListView()),
        ],
      ),
    );
  }
}
