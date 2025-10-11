
import 'package:userbarber/core/Models/OrderItem.dart';
import 'package:userbarber/core/Models/ProductModel.dart';
import 'package:userbarber/core/Utilities/cart_data.dart';
class product{
  void addItemfromProduct(String title, double price, String imgUrl) {
    final index = globalCartItems.indexWhere((item) => item.product.productName == title);

    if (index != -1) {
      // ✅ Item already exists – increment quantity
      globalCartItems[index].quantity += 1;
    } else {
      // 🆕 Item not in cart – add new item
      globalCartItems.add(OrderItem(
        product: ProductModel(
          productID: '',
          productName: title,
          productDescription: '',
          imgUrl: imgUrl,
          productPrice: price,
          productStatus: 'pending',
          productCategory: '',
        ),
        quantity: 1,
      ));
    }
  }
}