import 'OrderItem.dart';

class OrderModel {
  final String orderID;
  final String userId; // 👈 added
  final double totalPrice;
  final String orderDate;
  final int orderNumber;
  final String status;
  final List<OrderItem> items;
  final String paymentMethod;

  OrderModel({
    required this.orderID,
    required this.userId, // 👈 required
    required this.totalPrice,
    required this.orderDate,
    required this.orderNumber,
    required this.items,
    required this.status,
    required this.paymentMethod,
  });

  OrderModel copyWith({
    String? orderID,
    String? userId, // 👈 added
    double? totalPrice,
    String? orderDate,
    int? orderNumber,
    List<OrderItem>? items,
    String? status,
    String? paymentMethod,
  }) {
    return OrderModel(
      orderID: orderID ?? this.orderID,
      userId: userId ?? this.userId, // 👈 copy
      totalPrice: totalPrice ?? this.totalPrice,
      orderDate: orderDate ?? this.orderDate,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderID': orderID,
      'userId': userId, // 👈 added
      'totalPrice': totalPrice,
      'orderDate': orderDate,
      'orderNumber': orderNumber,
      'items': items.map((e) => e.toMap()).toList(),
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final items = (map['items'] as List<dynamic>?)
        ?.map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
        .toList() ??
        [];
    return OrderModel(
      orderID: map['orderID'] ?? '',
      userId: map['userId'] ?? '', // 👈 added
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      orderDate: map['orderDate'] ?? '',
      orderNumber: map['orderNumber'] ?? 0,
      items: items,
      status: map['status'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
    );
  }
}
