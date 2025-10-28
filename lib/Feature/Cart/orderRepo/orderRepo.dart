import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:userbarber/core/Services/FirestoreForOrders.dart';
import '../../../core/Models/OrderModel.dart';

class OrderRepository {
  final FireStoreForOrdersService firestore;

  OrderRepository({required this.firestore});

  CollectionReference<Map<String, dynamic>> get ordersCollection =>
      firestore.ordersCollection;

  /// Add order
  Future<void> addOrder(OrderModel order) async {
    await ordersCollection.doc(order.orderID).set(order.toMap());
  }

  /// Get all orders
  Future<List<OrderModel>> getAllOrders() async {
    final snapshot = await ordersCollection.get();
    return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList();
  }

  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      final snapshot = await ordersCollection
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel.fromMap(data).copyWith(orderID: doc.id);
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching orders for $userId: $e');
      return [];
    }
  }

  /// Get single order
  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await ordersCollection.doc(orderId).get();
    if (doc.exists) {
      return OrderModel.fromMap(doc.data()!);
    }
    return null;
  }

  /// Update order
  Future<void> updateOrder(OrderModel order) async {
    await ordersCollection.doc(order.orderID).update(order.toMap());
  }

  /// Update status only
  Future<void> updateOrderStatus(String orderId, String status) async {
    await ordersCollection.doc(orderId).update({'status': status});
  }

  /// Delete order
  Future<void> deleteOrder(String orderId) async {
    await ordersCollection.doc(orderId).delete();
  }
}
