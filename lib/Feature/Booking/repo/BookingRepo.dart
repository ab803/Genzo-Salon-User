import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:userbarber/core/Models/bookingModel.dart';
import 'package:userbarber/core/Services/FreStoreForBooking.dart';

class BookingRepo {
  final FirestoreForBooking _firestoreService = FirestoreForBooking();

  // add booking
  Future<void> addBooking(BookingModel booking) async {
    await _firestoreService.addBooking(booking);
  }

  // get booking by id
  Future<BookingModel?> getBookingById(String bookingId) async {
    DocumentSnapshot doc = await _firestoreService.getBookingById(bookingId);
    if (doc.exists) {
      return BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
  // get bookings by user id

  // ✅ get bookings by userId
  Future<List<BookingModel>> getBookingsByUserId(String userId) {
    return _firestoreService.getBookingsByUserId(userId);
  }

  // get all bookings
  Stream<List<BookingModel>> getBookings() {
    return _firestoreService.getBookings().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // update booking
  Future<void> updateBooking(String bookingId, BookingModel updatedBooking) async {
    await _firestoreService.UpdateBooking(bookingId, updatedBooking.toMap());
  }

  // delete booking
  Future<void> deleteBooking(String bookingId) async {
    await _firestoreService.deleteBooking(bookingId);
  }

}
