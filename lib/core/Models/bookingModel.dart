import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingModel {
  final String bookingid;
  final String userId; // 👈 added
  final int bookingNumber;
  final double totalPrice;
  final List<String> services;
  final TimeOfDay time;
  final DateTime date;
  final String PaymentMethod;

  BookingModel({
    required this.bookingid,
    required this.userId, // 👈 required
    required this.bookingNumber,
    required this.totalPrice,
    required this.services,
    required this.date,
    required this.time,
    required this.PaymentMethod,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BookingModel(
      bookingid: documentId,
      userId: map['userId'] ?? '', // 👈 added
      bookingNumber: (map['bookingNumber'] as num?)?.toInt() ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      services: List<String>.from(map['services'] ?? []),
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
      time: map['time'] != null
          ? TimeOfDay(
        hour: (map['time']['hour'] as num?)?.toInt() ?? 0,
        minute: (map['time']['minute'] as num?)?.toInt() ?? 0,
      )
          : const TimeOfDay(hour: 0, minute: 0),
      PaymentMethod: map['paymentMethod'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId, // 👈 added
      'bookingNumber': bookingNumber,
      'totalPrice': totalPrice,
      'services': services,
      'date': Timestamp.fromDate(date),
      'time': {'hour': time.hour, 'minute': time.minute},
      'paymentMethod': PaymentMethod,
    };
  }
}
