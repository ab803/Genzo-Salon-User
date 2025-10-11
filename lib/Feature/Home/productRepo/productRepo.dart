import 'package:userbarber/core/Models/productModel.dart';
import 'package:userbarber/core/Services/Firestore.dart';



class ProductRepository {
  final FirestoreService _productService;

  ProductRepository(this._productService);

  /// Add product
  Future<void> addProduct(ProductModel product) {
    return _productService.addProduct(product);
  }

  /// Get all products
  Future<List<ProductModel>> getProducts() {
    return _productService.getProducts();
  }

  /// Get single product
  Future<ProductModel?> getProductById(String id) {
    return _productService.getProductById(id);
  }

  /// Update product
  Future<void> updateProduct(ProductModel product) {
    return _productService.updateProduct(product);
  }

  /// Delete product
  Future<void> deleteProduct(String id) {
    return _productService.deleteProduct(id);
  }

  /// Real-time products stream
  Stream<List<ProductModel>> getProductsStream() {
    return _productService.getProductsStream();
  }
}
