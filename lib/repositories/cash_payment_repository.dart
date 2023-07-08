import 'package:flutter/cupertino.dart';
import '../models/cash_payment.dart';

class CashPaymentRepository extends ChangeNotifier {
  List<CashPayment> cashPayments = [];

  CashPaymentRepository ({
    required this.cashPayments
  });

  void add(CashPayment inCash) {
    cashPayments.add(inCash);
    notifyListeners();
  }

  void remove(int i) {
    cashPayments.removeAt(i);
    notifyListeners();
  }
}