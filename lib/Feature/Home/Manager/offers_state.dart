import 'package:userbarber/core/Models/offerModel.dart';

abstract class OffersState {}

class OffersInitial extends OffersState {}

class OffersLoading extends OffersState {}

class OffersLoaded extends OffersState {
  final List<OfferModel> offers;
  OffersLoaded(this.offers);
}

class OffersError extends OffersState {
  final String message;
  OffersError(this.message);
}
