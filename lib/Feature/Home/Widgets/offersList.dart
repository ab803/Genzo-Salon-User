import 'package:flutter/cupertino.dart';
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
import 'package:userbarber/Feature/Localization/Locales.dart'; // ✅ your localization

class OfferListView extends StatelessWidget {
  const OfferListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => OffersCubit(getIt<OffersRepo>())..listenToOffers(),
      child: BlocBuilder<OffersCubit, OffersState>(
        builder: (context, state) {
          if (state is OffersLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentyellow),
            );
          } else if (state is OffersLoaded) {
            final List<OfferModel> offers = state.offers;

            if (offers.isEmpty) {
              return Center(
                child: Text(
                  "noOffers".getString(context), // 🔑 localized
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.darkSecondaryText : Colors.grey,
                  ),
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return UserOfferCard(
                  offer: offer,
                  onTap: () {
                    final serviceFromOffer = Service(
                      id: offer.id,
                      name: offer.title,
                      description: offer.description,
                      price: offer.price,
                    );

                    globalServiceCartItems.add(serviceFromOffer);

                    Fluttertoast.showToast(
                      msg: "offerAdded".getString(context), // 🔑 localized
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
          } else if (state is OffersError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: isDark ? AppColors.accentyellow : Colors.red,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
