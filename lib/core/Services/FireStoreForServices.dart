import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userbarber/core/Models/Service.dart';

class FireStoreForService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = "Service";

  // ✅ Get all services
  Future<List<Service>> getServices() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map(
            (doc) =>
                Service.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    } catch (e) {
      throw Exception("Failed to load services: $e");
    }
  }
}
