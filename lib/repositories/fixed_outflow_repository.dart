import 'package:flutter/material.dart';
import 'package:iboss/models/fixed_outflow.dart';
import 'package:intl/intl.dart';


class FixedOutflowRepository extends ChangeNotifier {
  List<FixedOutflow> fixedOutflow = [];

  FixedOutflowRepository ({
    required this.fixedOutflow
  });

  void add(FixedOutflow fixed) {
    fixedOutflow.add(fixed);
    notifyListeners();
  }

  void remove(int i) {
    fixedOutflow.removeAt(i);
    notifyListeners();
  }

  double getTotalFixedOutflowByMonth(DateTime selectedMonth) {
    double total = 0.0;

    fixedOutflow.forEach((payment) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      if (paymentYear == selectedMonth.year &&
          paymentMonth == selectedMonth.month) {
        total += payment.value;
      }
    });
    return total;
  }

  List<FixedOutflow> getFixedOutflowsByMonth(DateTime selectedDate) {
    final String monthYearString = DateFormat('MM-yyyy').format(selectedDate);
    return fixedOutflow.where((expense) => DateFormat('MM-yyyy').format(expense.date) == monthYearString).toList();
  }
}
