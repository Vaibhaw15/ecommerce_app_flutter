import 'package:flutter/cupertino.dart';

class OrderDetailsProvider with ChangeNotifier {
  String? paymentMethod = "Pay-now";

  void changePaymentMethod(String? value) {
    paymentMethod = value;
    notifyListeners();
  }
}
