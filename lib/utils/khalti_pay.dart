import 'dart:convert';
import 'dart:math';

import 'package:cabira/utils/common.dart';
import 'package:cabira/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:khalti_flutter/khalti_flutter.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'Session.dart';

String razorPayKey = "rzp_test_K7iUQiyMNy1FIT";
String razorPaySecret = "Bb03yFC5dGa9lXTtLnF3qkXQ";

class KhaltiPayHelper {
  String amount;
  String? orderId;
  BuildContext context;
  ValueChanged onResult;
  Razorpay? _razorpay;
  KhaltiPayHelper(this.amount, this.context, this.onResult);
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  init() {
    orderId = "order_" + getRandomString(6);

    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: int.parse(amount), //in paisa
        productIdentity: orderId!,
        productName: 'AlphaTaxi',
        mobile: '9800003001',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    onResult(success.idx);
    setSnackbar("Payment Done", context);
  }

  void onFailure(PaymentFailureModel failure) {
    onResult("error");
    setSnackbar("Payment Failed", context);
    debugPrint(
      failure.toString(),
    );
  }

  void onCancel() {
    onResult("error");
    setSnackbar("Payment Cancelled", context);
    debugPrint('Cancelled');
  }
}
