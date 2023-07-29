import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  void remove(int i, String monthYearString) {
    deferredPayments.removeAt(i);
    notifyListeners();
  }

  List<DeferredPayment> getDeferredPaymentsByMonth(DateTime selectedMonth) {
    return deferredPayments.where((payment) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      return paymentYear == selectedMonth.year && paymentMonth == selectedMonth.month;
    }).toList();
  }
}