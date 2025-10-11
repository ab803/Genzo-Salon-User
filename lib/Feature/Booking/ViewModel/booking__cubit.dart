import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__state.dart';
import 'package:userbarber/core/Models/bookingModel.dart';
import '../Repo/bookingRepo.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo bookingRepo;
  StreamSubscription? _bookingSubscription;

  BookingCubit({required this.bookingRepo}) : super(BookingInitial());

  /// ✅ Listen to all bookings in real-time
  Future<void> listenToBookings() async {
    emit(BookingLoading());
    await _bookingSubscription?.cancel(); // cancel old listener if exists

    _bookingSubscription = bookingRepo.getBookings().listen(
          (bookings) {
        emit(BookingLoaded(bookings));
      },
      onError: (e) {
        emit(BookingError(e.toString()));
      },
    );
  }

  // ✅ load bookings by userId
  Future<void> loadBookings(String userId) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepo.getBookingsByUserId(userId);
      emit(BookingLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  /// ✅ Get booking by ID (single fetch)
  Future<void> getBookingById(String bookingId) async {
    emit(BookingLoading());
    try {
      final booking = await bookingRepo.getBookingById(bookingId);
      if (booking != null) {
        emit(BookingLoaded([booking])); // wrap in list
      } else {
        emit(const BookingError("Booking not found"));
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  /// ✅ Add booking + schedule reminder
  Future<void> addBooking(BookingModel booking, String userId) async {
    emit(BookingLoading());
    try {
      await bookingRepo.addBooking(booking);
      emit(const BookingActionSuccess("Booking added successfully"));
      await loadBookings(userId);
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  /// ✅ Update booking + reschedule reminder
  Future<void> updateBooking(String bookingId, BookingModel updatedBooking) async {
    emit(BookingLoading());
    try {
      await bookingRepo.updateBooking(bookingId, updatedBooking);


      emit(const BookingActionSuccess("Booking updated successfully"));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  /// ✅ Delete booking + cancel reminder
  Future<void> deleteBooking(String bookingId, int bookingNumber) async {
    emit(BookingLoading());
    try {
      await bookingRepo.deleteBooking(bookingId);


      emit(const BookingActionSuccess("Booking deleted successfully"));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  /// ✅ Close subscription on dispose
  @override
  Future<void> close() {
    _bookingSubscription?.cancel();
    return super.close();
  }
}
