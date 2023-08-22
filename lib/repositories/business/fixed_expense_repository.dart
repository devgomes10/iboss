import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/business/fixed_expense.dart';


class FixedExpenseRepository extends ChangeNotifier {
  List<FixedExpense> fixedExpenses = [];

  FixedExpenseRepository ({
    required this.fixedExpenses
  });

  void add(FixedExpense fixed) {
    fixedExpenses.add(fixed);
    notifyListeners();
  }

  void remove(int i) {
    fixedExpenses.removeAt(i);
    notifyListeners();
  }

  double getTotalFixedExpensesByMonth(DateTime selectedMonth) {
    double total = 0.0;

    for (var payment in fixedExpenses) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      if (paymentYear == selectedMonth.year &&
          paymentMonth == selectedMonth.month) {
        total += payment.value;
      }
    }
    return total;
  }

  List<FixedExpense> getFixedExpensesByMonth(DateTime selectedDate) {
    final String monthYearString = DateFormat('MM-yyyy').format(selectedDate);
    return fixedExpenses.where((expense) => DateFormat('MM-yyyy').format(expense.date) == monthYearString).toList();
  }
}