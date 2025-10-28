import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/OrderModel.dart';

class FireStoreForOrdersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Firestore collection reference for orders
  CollectionReference<Map<String, dynamic>> get ordersCollection =>
      _firestore.collection('orders');

  /// Add a new order
  Future<void> addOrder(OrderModel order) async {
    try {
      await ordersCollection.doc(order.orderID).set(order.toMap());
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  /// Get a single order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await ordersCollection
          .doc(orderId)
          .get();

      if (doc.exists && doc.data() != null) {
        return OrderModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  /// Get all orders
  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      final snapshot = await ordersCollection
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user orders: $e');
    }
  }

  /// Update an existing order (by ID)
  Future<void> updateOrder(OrderModel order) async {
    try {
      await ordersCollection.doc(order.orderID).update(order.toMap());
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  /// Update order status only
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await ordersCollection.doc(orderId).update({'status': status});
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      await ordersCollection.doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }
}
