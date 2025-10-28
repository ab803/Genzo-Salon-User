import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userbarber/core/Models/offerModel.dart';

class OffersRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "offers";

  /// Add new offer
  Future<void> addOffer(OfferModel offer) async {
    await _firestore.collection(collectionName).add(offer.toMap());
  }

  /// Get all offers (Stream)
  Stream<List<OfferModel>> getOffers() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OfferModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Get a single offer by ID
  Future<OfferModel?> getOfferById(String offerId) async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .doc(offerId)
          .get();
      if (doc.exists) {
        return OfferModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception("❌ Failed to get offer: $e");
    }
  }

  /// Update offer
  Future<void> updateOffer(String id, OfferModel offer) async {
    await _firestore.collection(collectionName).doc(id).update(offer.toMap());
  }

  /// Delete offer
  Future<void> deleteOffer(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}
