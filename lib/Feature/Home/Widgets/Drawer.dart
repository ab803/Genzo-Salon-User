import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_cubit.dart';
import 'package:userbarber/Feature/Home/Widgets/DrawerWidgets/DrawerActionList.dart';
import 'package:userbarber/Feature/Home/Widgets/DrawerWidgets/LanguageCard.dart';
import 'package:userbarber/Feature/Home/Widgets/DrawerWidgets/ThemeToggleCard.dart';
import 'package:userbarber/Feature/Home/Widgets/DrawerWidgets/UserInfoHeader.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/Feature/ValueNotifier.dart';


class AppSettingsDrawer extends StatefulWidget {
  const AppSettingsDrawer({super.key});

  @override
  State<AppSettingsDrawer> createState() => _AppSettingsDrawerState();
}

class _AppSettingsDrawerState extends State<AppSettingsDrawer> {
  // Variables to hold current settings
  late bool isDarkMode;
  String selectedLanguage = 'En';
  final List<String> languages = ['En', 'ع'];
  late FlutterLocalization localization;
  // function to calculate responsive font size
  double responsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    return baseSize * (screenWidth / 375);
  }

  @override
  void initState() {
    super.initState();
    localization = FlutterLocalization.instance;
    isDarkMode = themeNotifier.value == ThemeMode.dark;
    selectedLanguage =
    localization.currentLocale?.languageCode == 'ar' ? 'ع' : 'En';
    context.read<AuthCubit>().loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    // value to check if current theme is dark
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 👤 User info header
              UserInfoHeader(responsiveFontSize: responsiveFontSize),

              const Divider(height: 30, thickness: 1),

              /// 🔤 Language selection
              LanguageCard(
                isDark: isDark,
                languages: languages,
                selectedLanguage: selectedLanguage,
                localization: localization,
                responsiveFontSize: responsiveFontSize,
                onLanguageChanged: (value) async {
                  if (value == 'En') {
                    localization.translate('en');
                    await saveLocale('en');
                  } else {
                    localization.translate('ar');
                    await saveLocale('ar');
                  }
                  setState(() => selectedLanguage = value);
                },
              ),

              const SizedBox(height: 16),

              /// 🌙 Dark mode toggle
              ThemeToggleCard(
                isDark: isDark,
                isDarkMode: isDarkMode,
                responsiveFontSize: responsiveFontSize,
                onToggle: (value) async {
                  setState(() => isDarkMode = value);
                  themeNotifier.value =
                  value ? ThemeMode.dark : ThemeMode.light;
                  await saveTheme(value);
                },
              ),

              const Spacer(),

              /// ℹ️ About & Logout
              DrawerActionList(
                isDark: isDark,
                responsiveFontSize: responsiveFontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
