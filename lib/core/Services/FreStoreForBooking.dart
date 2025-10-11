import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userbarber/core/Models/bookingModel.dart';

import 'package:userbarber/core/Utilities/app_router.dart';

class FirestoreForBooking {

  // A` reference to the Firestore collection for bookings
  final CollectionReference bookings =
  FirebaseFirestore.instance.collection('booking');


  // add a new booking
  Future<void> addBooking(BookingModel booking) async {
    try {
      await bookings.add(booking.toMap());

    } on Exception catch (e) {
      throw Exception('Failed to add booking: $e');
    }
  }

  // fetch data of all bookings
  Stream<QuerySnapshot> getBookings() {
    try {
      return bookings.snapshots();
    } on Exception catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  Future<List<BookingModel>> getBookingsByUserId(String userId) async {
    try {
      final snapshot =
      await bookings.where('userId', isEqualTo: userId).get();
      return snapshot.docs
          .map((doc) =>
          BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } on Exception catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  // fetch a single booking by ID
  Future<DocumentSnapshot> getBookingById(String bookingId) async {
    try {
      return await bookings.doc(bookingId).get();
    } on Exception catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  // update an existing booking by ID
  Future<void> UpdateBooking(String bookingId, Map<String, dynamic> updatedData) async {
    try {
      await bookings.doc(bookingId).update(updatedData);
    } on Exception catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  // delete a booking by ID
  Future<void> deleteBooking(String bookingId) async {
    try {
      await bookings.doc(bookingId).delete();
    } on Exception catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }

}