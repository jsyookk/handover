

import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';


class PaymentService{

  PaymentService._internal();

  static final PaymentService instance = PaymentService._internal();

  bool _isProUser = false;

  bool get isProUser => _isProUser;


}