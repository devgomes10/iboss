import 'package:flutter/material.dart';
import '../models/deferred_payment.dart';

class DeferredPaymentRepository extends ChangeNotifier {
  List<DeferredPayment> deferredPayments = [];

  DeferredPaymentRepository ({
    required this.deferredPayments
  });

  void add(DeferredPayment inTerm) {
    deferredPayments.add(inTerm);
    notifyListeners();
  }

  void remove(int i) {
    deferredPayments.removeAt(i);
    notifyListeners();
  }
}