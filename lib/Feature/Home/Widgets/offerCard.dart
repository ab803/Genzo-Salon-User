import 'package:flutter/material.dart';
import 'package:userbarber/core/Models/offerModel.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

/// A card widget that displays a special user offer, including:
/// - Offer title and description
/// - Localized price text
/// - Optional “Book Now” button
///
/// Used in the Home or Offers section to attract users with promotions or deals.
class UserOfferCard extends StatelessWidget {
  /// Model containing offer details like title, description, and price.
  final OfferModel offer;

  /// Optional callback triggered when the card or button is tapped.
  final VoidCallback? onTap;

  const UserOfferCard({
    super.key,
    required this.offer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Detect if the current app theme is dark mode
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      // Makes the entire card tappable
      onTap: onTap,
      // Adds a ripple effect with rounded corners when tapped
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        // Sets the width relative to screen size for responsiveness
        width: MediaQuery.of(context).size.width * 0.88,
        child: Container(
          // Adds horizontal spacing between cards
          margin: const EdgeInsets.symmetric(horizontal: 8),
          // Internal padding for content spacing
          padding: const EdgeInsets.all(16),
          // Card background and shadow styling
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),

          // 🔹 Card content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Offer title (main heading)
              Text(
                offer.title,
                style: AppTextStyles.subheading(
                  isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(height: 6),

              // Offer description (secondary text)
              Text(
                offer.description,
                style: AppTextStyles.body(
                  isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.lightSecondaryText,
                ),
              ),
              const SizedBox(height: 12),

              // 🔹 Bottom row: price and optional “Book Now” button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display the price with localization support
                  // Example: “EGP 200.00” or localized equivalent
                  Text(
                    "currencyEGP"
                        .getString(context)
                        .replaceFirst("{price}", offer.price.toStringAsFixed(2)),
                    style: AppTextStyles.subheading(AppColors.accentyellow),
                  ),

                  // Show "Book Now" button only if onTap is provided
                  if (onTap != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentyellow,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: onTap,
                      child: Text(
                        "bookNow".getString(context), // Localized label
                        style: AppTextStyles.button(
                          isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
