import 'package:flutter/material.dart';
import 'package:iboss/models/fixed_expense.dart';
import 'package:intl/intl.dart';


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

  List<FixedExpense> getFixedExpensesByMonth(DateTime selectedDate) {
    final String monthYearString = DateFormat('MM-yyyy').format(selectedDate);
    return fixedExpenses.where((expense) => DateFormat('MM-yyyy').format(expense.date) == monthYearString).toList();
  }
}