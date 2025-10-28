import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass/liquid_glass.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/Home/Widgets/Drawer.dart';
import 'package:userbarber/Feature/Localization/Locales.dart';
import 'package:userbarber/core/Styles/Styles.dart';


class ScaffoldWithNav extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const ScaffoldWithNav({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  String getLabel(String key) {
    final locale =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'en';
    final map = locales
        .firstWhere((element) => element.languageCode == locale)
        .mapData;
    return map[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      endDrawer: const AppSettingsDrawer(),
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: LiquidGlass(
                  blur: 30,
                  opacity: 0.2,
                  tint: Colors.white,
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    selectedItemColor: AppColors.accentyellow,
                    unselectedItemColor: isDark
                        ? AppColors.darkText
                        : AppColors.lightText,
                    currentIndex: selectedIndex,
                    onTap: (index) {
                      switch (index) {
                        case 0:
                          context.go('/home');
                          break;
                        case 1:
                          context.go('/booking');
                          break;
                        case 2:
                          context.go('/cart');
                          break;
                      }
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.home_outlined),
                        label: getLabel('navHome'), // localized
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: getLabel('navBookings'), // localized
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.shopping_cart),
                        label: getLabel('navCart'), // localized
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
