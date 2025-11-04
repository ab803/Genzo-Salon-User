import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userbarber/Feature/Home/Manager/offers_cubit.dart';
import 'package:userbarber/Feature/Home/Manager/offers_state.dart';
import 'package:userbarber/Feature/Home/Widgets/offerCard.dart';
import 'package:userbarber/Feature/Home/offersRepo.dart';
import 'package:userbarber/core/Models/offerModel.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Utilities/getit.dart';
import 'package:userbarber/core/Utilities/serviceList.dart';
import 'package:userbarber/core/Models/Service.dart';

/// A horizontally scrollable list that displays promotional offers.
///
/// It listens to [OffersCubit] to fetch and update offers in real time.
/// - Shows a loading spinner while fetching data.
/// - Displays localized text if there are no offers.
/// - On tapping an offer, adds it to the global service cart and shows a toast.
class OfferListView extends StatelessWidget {
  const OfferListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect if the current app theme is dark mode
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      // Provide an instance of OffersCubit and immediately start listening for offers
      create: (_) => OffersCubit(getIt<OffersRepo>())..listenToOffers(),

      // Rebuild the UI when the offers state changes
      child: BlocBuilder<OffersCubit, OffersState>(
        builder: (context, state) {
          // 🔹 CASE 1: Still loading data
          if (state is OffersLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentyellow),
            );
          }

          // 🔹 CASE 2: Successfully loaded offers
          else if (state is OffersLoaded) {
            final List<OfferModel> offers = state.offers;

            // If no offers are available
            if (offers.isEmpty) {
              return Center(
                child: Text(
                  "noOffers".getString(context), // Localized string for “No offers available”
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.darkSecondaryText : Colors.grey,
                  ),
                ),
              );
            }

            // 🔹 Render horizontal list of offers
            return ListView.builder(
              scrollDirection: Axis.horizontal, // Horizontal scrolling
              physics: const BouncingScrollPhysics(), // Smooth iOS-style scroll
              padding: const EdgeInsets.all(8),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];

                return UserOfferCard(
                  offer: offer,

                  // When an offer is tapped:
                  onTap: () {
                    // Convert the selected offer into a service model
                    final serviceFromOffer = Service(
                      id: offer.id,
                      name: offer.title,
                      description: offer.description,
                      price: offer.price,
                    );

                    // Add the service to the global service cart list
                    globalServiceCartItems.add(serviceFromOffer);

                    // Show a confirmation toast message
                    Fluttertoast.showToast(
                      msg: "offerAdded".getString(context), // Localized success message
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      backgroundColor: AppColors.accentyellow,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                );
              },
            );
          }

          // 🔹 CASE 3: Error occurred while loading offers
          else if (state is OffersError) {
            return Center(
              child: Text(
                state.message, // Display the error message from the cubit
                style: TextStyle(
                  color: isDark ? AppColors.accentyellow : Colors.red,
                ),
              ),
            );
          }

          // 🔹 Default fallback: empty space (no UI)
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
