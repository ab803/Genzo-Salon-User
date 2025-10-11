import 'package:equatable/equatable.dart';
import '../../../core/Models/bookingModel.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final List<BookingModel> bookings;

  const BookingSuccess(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingLoaded extends BookingState {
  final List<BookingModel> booking;

  const BookingLoaded(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingActionSuccess extends BookingState {
  final String message; // e.g. "Booking added successfully"

  const BookingActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}



