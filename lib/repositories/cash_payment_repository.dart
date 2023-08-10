import 'package:flutter/material.dart';
import '../models/cash_payment.dart';

class CashPaymentRepository extends ChangeNotifier {
  List<CashPayment> cashPayments = [];

  CashPaymentRepository({required this.cashPayments});

  void add(CashPayment inCash) {
    cashPayments.add(inCash);
    notifyListeners();
  }

  void remove(int i, String monthYearString) {
    cashPayments.removeAt(i);
    notifyListeners();
  }

  double getTotalCashPayments() {
    double total = 0.0;

    cashPayments.forEach((payment) {
      total += payment.value;
    });

    return total;
  }

  double getTotalCashPaymentsByMonth(DateTime selectedMonth) {
    double total = 0.0;

    cashPayments.forEach((payment) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      if (paymentYear == selectedMonth.year &&
          paymentMonth == selectedMonth.month) {
        total += payment.value;
      }
    });
    return total;
  }

  List<CashPayment> getCashPaymentsByMonth(DateTime selectedMonth) {
    return cashPayments.where((payment) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      return paymentYear == selectedMonth.year &&
          paymentMonth == selectedMonth.month;
    }).toList();
  }
}
