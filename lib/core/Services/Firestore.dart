import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userbarber/core/Models/productModel.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'products';

  /// Add product to Firestore
  Future<void> addProduct(ProductModel product) async {
    await _firestore
        .collection(_collectionName)
        .doc(product.productID) // Use productID as document ID
        .set(product.toMap());
  }

  /// Get all products
  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection(_collectionName)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data()))
        .toList();
  }

  /// Get a single product by ID
  Future<ProductModel?> getProductById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection(_collectionName)
        .doc(id)
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        return ProductModel.fromMap(data);
      }
    }
    return null;
  }

  /// Update product
  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection(_collectionName)
        .doc(product.productID)
        .update(product.toMap());
  }

  /// Delete product
  Future<void> deleteProduct(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }

  /// Real-time products stream
  Stream<List<ProductModel>> getProductsStream() {
    return _firestore
        .collection(_collectionName)
        .snapshots()
        .map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data()))
              .toList(),
        );
  }
}
