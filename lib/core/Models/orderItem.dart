import 'ProductModel.dart';

class OrderItem {
  final ProductModel product;
  int quantity;

  OrderItem({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: ProductModel.fromMap(map['product']),
      quantity:(map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}