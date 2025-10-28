class ProductModel {
  final String productID;
  final String productName;
  final String productDescription;
  final String imgUrl;
  final double productPrice;
  final String productStatus;
  final String productCategory;

  ProductModel({
    required this.productID,
    required this.productName,
    required this.productDescription,
    required this.imgUrl,
    required this.productPrice,
    this.productStatus = 'available',
    required this.productCategory,
  });

  /// Create ProductModel from Firestore document
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productID: map['productID'] ?? '',
      productName: map['productName'] ?? '',
      productDescription: map['productDescription'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      productPrice: (map['productPrice'] is int)
          ? (map['productPrice'] as int).toDouble()
          : (map['productPrice'] ?? 0.0),
      productStatus: map['productStatus'] ?? 'available',
      productCategory: map['ProductCategory'] ?? '',
    );
  }

  /// Convert ProductModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productID': productID,
      'productName': productName,
      'productDescription': productDescription,
      'imgUrl': imgUrl,
      'productPrice': productPrice,
      'productStatus': productStatus,
      'ProductCategory': productCategory,
    };
  }
}
