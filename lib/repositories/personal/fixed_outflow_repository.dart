import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/personal/fixed_outflow.dart';


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

    for (var payment in fixedOutflow) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      if (paymentYear == selectedMonth.year &&
          paymentMonth == selectedMonth.month) {
        total += payment.value;
      }
    }
    return total;
  }

  List<FixedOutflow> getFixedOutflowsByMonth(DateTime selectedDate) {
    final String monthYearString = DateFormat('MM-yyyy').format(selectedDate);
    return fixedOutflow.where((expense) => DateFormat('MM-yyyy').format(expense.date) == monthYearString).toList();
  }
}
