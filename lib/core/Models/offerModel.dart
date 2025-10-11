class OfferModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String PaymentMethod;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.PaymentMethod,
  });

  /// Firestore → Model
  factory OfferModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return OfferModel(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : (data['price'] ?? 0.0),
      PaymentMethod: '',
    );
  }

  /// Model → Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'PaymentMethod': PaymentMethod,
    };
  }
}
