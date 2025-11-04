// Small helper utilities for SearchView
String formatPrice(dynamic priceValue) {
  double? priceNum;
  if (priceValue is num) {
    priceNum = priceValue.toDouble();
  } else if (priceValue is String) {
    priceNum = double.tryParse(priceValue);
  }

  return priceNum != null ? priceNum.toStringAsFixed(2) : '0.00';
}

/// Filters a list of product maps by productName containing the query (case-insensitive).
List<Map<String, dynamic>> filterProducts(
  List<Map<String, dynamic>> allList,
  String query,
) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return List.from(allList);

  final List<Map<String, dynamic>> results = [];
  for (final product in allList) {
    final title = (product['productName'] ?? '').toString().toLowerCase();
    if (title.contains(q)) results.add(product);
  }
  return results;
}
