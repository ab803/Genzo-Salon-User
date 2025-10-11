import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userbarber/core/Styles/Styles.dart';

// Global ValueNotifier for dynamic theme
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

// Load saved theme from SharedPreferences
Future<void> loadTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDark = prefs.getBool('isDarkMode') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
}

// Save selected theme to SharedPreferences
Future<void> saveTheme(bool isDark) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDarkMode', isDark);
}

// Save locale
Future<void> saveLocale(String languageCode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('locale', languageCode);
  localeNotifier.value = Locale(languageCode);
}




extension ThemeColors on BuildContext {
  Color get backgroundColor =>
      Theme.of(this).brightness == Brightness.dark
          ? AppColors.darkBackground
          : AppColors.lightBackground;

  Color get cardColor =>
      Theme.of(this).brightness == Brightness.dark
          ? AppColors.darkCard
          : AppColors.lightCard;

  Color get textColor =>
      Theme.of(this).brightness == Brightness.dark
          ? AppColors.darkText
          : AppColors.lightText;

  Color get secondaryTextColor =>
      Theme.of(this).brightness == Brightness.dark
          ? AppColors.darkSecondaryText
          : AppColors.lightSecondaryText;
}