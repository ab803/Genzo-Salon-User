import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

/// A card widget that allows users to switch between supported languages.
///
/// It displays a localized label (e.g., "Language") and a dropdown menu
/// for selecting the app language. The selected language triggers a callback
/// to update localization settings and persist the choice.
class LanguageCard extends StatelessWidget {
  /// Determines if the app is currently in dark mode.
  final bool isDark;

  /// List of available languages to display in the dropdown.
  final List<String> languages;

  /// Currently selected language (e.g., "En" or "ع").
  final String selectedLanguage;

  /// FlutterLocalization instance used to handle language switching.
  final FlutterLocalization localization;

  /// Function that calculates responsive font size based on screen width.
  final double Function(BuildContext, double) responsiveFontSize;

  /// Callback triggered when user selects a new language.
  final ValueChanged<String> onLanguageChanged;

  const LanguageCard({
    super.key,
    required this.isDark,
    required this.languages,
    required this.selectedLanguage,
    required this.localization,
    required this.responsiveFontSize,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Card background color adapts to dark/light mode
      color: isDark ? AppColors.darkCard : AppColors.lightCard,

      // Rounded corners for a modern design
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🏷 Title: "Language" (localized text)
            Text(
              'language'.getString(context),
              style: AppTextStyles.subheading(
                isDark ? AppColors.darkText : AppColors.lightText,
              ).copyWith(fontSize: responsiveFontSize(context, 18)),
            ),

            const SizedBox(height: 8),

            /// 🌍 Dropdown for choosing between available languages
            DropdownButtonFormField<String>(
              value: selectedLanguage,

              // Text style adapts to dark/light mode
              style: AppTextStyles.body(
                isDark ? AppColors.darkText : AppColors.lightText,
              ).copyWith(fontSize: responsiveFontSize(context, 14)),

              // Dropdown background adapts to theme
              dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,

              // Input decoration for styling
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),

              // Generate dropdown items from the list of languages
              items: languages
                  .map(
                    (lang) => DropdownMenuItem(
                  value: lang,
                  child: Text(
                    lang,
                    style: AppTextStyles.body(
                      isDark
                          ? AppColors.darkText
                          : AppColors.lightText,
                    ).copyWith(fontSize: responsiveFontSize(context, 14)),
                  ),
                ),
              )
                  .toList(),

              // When user selects a new language
              onChanged: (value) {
                if (value != null) onLanguageChanged(value);
              },

              // Down arrow icon color adapts to theme
              icon: Icon(
                Icons.arrow_drop_down,
                color: isDark ? AppColors.darkText : AppColors.primaryNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
