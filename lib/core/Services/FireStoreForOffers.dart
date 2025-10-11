import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreForOffers {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "offers";



  /// ✅ Get all offers
  Stream<QuerySnapshot> getOffers() {
    return _firestore.collection(collectionName).snapshots();
  }



}
