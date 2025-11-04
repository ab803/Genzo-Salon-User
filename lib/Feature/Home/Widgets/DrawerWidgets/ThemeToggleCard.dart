import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';

/// A reusable card widget that toggles the app’s theme between
/// light and dark mode using a `SwitchListTile`.
///
/// Displays a localized label ("Dark Mode") and updates the theme
/// through the provided callback when toggled.
class ThemeToggleCard extends StatelessWidget {
  /// Determines if the current app theme is dark or light (used for styling).
  final bool isDark;

  /// Reflects whether dark mode is currently enabled (controls switch value).
  final bool isDarkMode;

  /// Function that calculates responsive font size based on screen width.
  final double Function(BuildContext, double) responsiveFontSize;

  /// Callback triggered when user toggles the dark mode switch.
  final ValueChanged<bool> onToggle;

  const ThemeToggleCard({
    super.key,
    required this.isDark,
    required this.isDarkMode,
    required this.responsiveFontSize,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Adapts the card color to dark/light theme
      color: isDark ? AppColors.darkCard : AppColors.lightCard,

      // Rounded corners for consistent design
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: SwitchListTile(
        // Adds horizontal padding for spacing
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),

        // Active switch color (accent highlight)
        activeColor: AppColors.accentyellow,

        // Localized text for “Dark Mode”
        title: Text(
          "darkMode".getString(context),
          style: AppTextStyles.body(
            isDark ? AppColors.darkText : AppColors.lightText,
          ).copyWith(fontSize: responsiveFontSize(context, 14)),
        ),

        // Whether dark mode is currently enabled
        value: isDarkMode,

        // Handles toggle state change (passed from parent)
        onChanged: onToggle,
      ),
    );
  }
}
