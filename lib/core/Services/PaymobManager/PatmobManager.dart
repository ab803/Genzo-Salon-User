import 'package:dio/dio.dart';
import 'package:userbarber/core/Services/PaymobManager/Constants.dart';




class PaymobManager {
  final Dio _dio = Dio();

  /// Get payment key to use inside the Iframe
  Future<String> getPaymentKey(int amount, String currency) async {
    try {
      String authToken = await _getAuthToken();
      int orderId = await _getOrderId(authToken, 100 * amount, currency);
      String paymentKey = await _getPaymentKey(
        authToken,
        (100 * amount).toString(),
        currency,
        orderId.toString(),
      );
      return paymentKey;
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.response?.data}");
      throw Exception("Failed to get payment key");
    } catch (e) {
      print("❌ General Error: $e");
      throw Exception("Failed to get payment key");
    }
  }

  /// Step 1: Get Authentication Token
  Future<String> _getAuthToken() async {
    final response = await _dio.post(
      "https://accept.paymob.com/api/auth/tokens",
      data: {"api_key": Constants.apiKey},
    );
    return response.data["token"];
  }

  /// Step 2: Register Order
  Future<int> _getOrderId(
      String authToken, int amount, String currency) async {
    final response = await _dio.post(
      "https://accept.paymob.com/api/ecommerce/orders",
      data: {
        "auth_token": authToken,
        "delivery_needed": "false",
        "amount_cents": amount,
        "currency": currency,
        "items": [],
      },
    );
    return response.data["id"];
  }

  /// Step 3: Get Payment Key
  Future<String> _getPaymentKey(
      String authToken,
      String amount,
      String currency,
      String orderId,
      ) async {
    final response = await _dio.post(
      "https://accept.paymob.com/api/acceptance/payment_keys",
      data: {
        "auth_token": authToken,
        "amount_cents": amount,
        "expiration": 3600,
        "order_id": orderId,
        "currency": currency,

        "integration_id": Constants.integrationId,
        "billing_data": {
          "apartment": "NA",
          "email": "test@example.com",
          "floor": "NA",
          "first_name": "Test",
          "street": "NA",
          "building": "NA",
          "phone_number": "+201000000000",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "Cairo",
          "country": "EG",
          "last_name": "Account",
          "state": "NA"
        },
        // redirection URL for Flutter callback
        "redirection_url": "myapp://payment-callback"
      },

    );
    return response.data["token"];
  }
}
