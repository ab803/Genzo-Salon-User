class Service {
  final String id;
  final String name;
  final String description;
  final double price;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  // ✅ Convert Firestore document to ServiceModel
  factory Service.fromMap(Map<String, dynamic> data, String documentId) {
    return Service(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
    );
  }
}
