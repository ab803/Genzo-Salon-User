import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userbarber/Feature/Home/productRepo/productRepo.dart';
import 'package:userbarber/core/Models/productModel.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;

  ProductCubit(this.productRepository) : super(ProductInitial());

  /// Fetch products once
  Future<void> fetchProducts() async {
    try {
      emit(ProductLoading());
      final products = await productRepository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  /// Listen for real-time product updates
  void listenToProducts() {
    emit(ProductLoading());
    productRepository.getProductsStream().listen(
      (products) {
        emit(ProductLoaded(products));
      },
      onError: (error) {
        emit(ProductError(error.toString()));
      },
    );
  }

  /// Add product
  Future<void> addProduct(ProductModel product) async {
    try {
      await productRepository.addProduct(product);
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  /// Update product
  Future<void> updateProduct(ProductModel product) async {
    try {
      await productRepository.updateProduct(product);
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  /// Delete product
  Future<void> deleteProduct(String id) async {
    try {
      await productRepository.deleteProduct(id);
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
