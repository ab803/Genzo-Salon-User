import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userbarber/core/Services/PaymobManager/Constants.dart';
import 'package:userbarber/core/Services/PaymobManager/PatmobManager.dart';

/// ✅ Handles Paymob payment logic (open iframe)
class PaymentHelper{
  /// 🔹 Pay with credit card using Paymob
  static Future<void> payWithCard(double total) async {
    try {
      // Get payment token
      String paymentKey = await PaymobManager().getPaymentKey(
        total.toInt(),
        "EGP",
      );

      final url =
          "https://accept.paymob.com/api/acceptance/iframes/${Constants.iframeId}?payment_token=$paymentKey";

      // Launch payment page
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("❌ Payment failed: $e");
      Fluttertoast.showToast(
        msg: "Payment failed, please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
