import 'package:flutter/material.dart';
import 'package:userbarber/core/Models/offerModel.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Styles/TextStyles.dart';
import 'package:flutter_localization/flutter_localization.dart';

class UserOfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback? onTap;

  const UserOfferCard({super.key, required this.offer, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.88,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: MediaQuery.of(context).size.width * 0.75,
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer.title,
                style: AppTextStyles.subheading(
                  isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                offer.description,
                style: AppTextStyles.body(
                  isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.lightSecondaryText,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // 🔑 localized price string
                    "currencyEGP"
                        .getString(context)
                        .replaceFirst(
                          "{price}",
                          offer.price.toStringAsFixed(2),
                        ),
                    style: AppTextStyles.subheading(AppColors.accentyellow),
                  ),
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
                        "bookNow".getString(context), // 🔑 localized
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
