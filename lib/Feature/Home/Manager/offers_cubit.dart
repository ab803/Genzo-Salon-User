import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userbarber/Feature/Home/offersRepo.dart';
import 'package:userbarber/core/Models/offerModel.dart';
import 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final OffersRepo offersRepo;

  OffersCubit(this.offersRepo) : super(OffersInitial());

  /// Listen for offers (real-time)
  void listenToOffers() {
    emit(OffersLoading());
    offersRepo.getOffers().listen((offers) {
      emit(OffersLoaded(offers));
    }, onError: (e) {
      emit(OffersError("Failed to load offers: $e"));
    });
  }

  /// Add offer
  Future<void> addOffer(OfferModel offer) async {
    try {
      await offersRepo.addOffer(offer);
    } catch (e) {
      emit(OffersError("Failed to add offer: $e"));
    }
  }

  /// Update offer
  Future<void> updateOffer(String id, OfferModel offer) async {
    try {
      await offersRepo.updateOffer(id, offer);
    } catch (e) {
      emit(OffersError("Failed to update offer: $e"));
    }
  }

  /// Delete offer
  Future<void> deleteOffer(String id) async {
    try {
      await offersRepo.deleteOffer(id);
    } catch (e) {
      emit(OffersError("Failed to delete offer: $e"));
    }
  }
}
