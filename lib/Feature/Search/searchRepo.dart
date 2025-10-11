// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class SearchRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<List<Map<String, dynamic>>> searchAll(String query) async {
//     query = query.toLowerCase();
//
//     // ✅ Search services
//     final servicesSnapshot = await _firestore
//         .collection("Service")
//         .where("name", isGreaterThanOrEqualTo: query)
//         .where("name", isLessThanOrEqualTo: "$query\uf8ff")
//         .get();
//
//     // ✅ Search offers
//     final offersSnapshot = await _firestore
//         .collection("offers")
//         .where("title", isGreaterThanOrEqualTo: query)
//         .where("title", isLessThanOrEqualTo: "$query\uf8ff")
//         .get();
//
//     // ✅ Search products
//     final productsSnapshot = await _firestore
//         .collection("products")
//         .where("productName", isGreaterThanOrEqualTo: query)
//         .where("productName", isLessThanOrEqualTo: "$query\uf8ff")
//         .get();
//
//     // Merge results into one list
//     return [
//       ...servicesSnapshot.docs.map((d) => {...d.data(), "type": "service"}),
//       ...offersSnapshot.docs.map((d) => {...d.data(), "type": "offer"}),
//       ...productsSnapshot.docs.map((d) => {...d.data(), "type": "product"}),
//     ];
//   }
// }
