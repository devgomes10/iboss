import 'package:flutter/material.dart';
import 'package:iboss/models/fixed_expense.dart';


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
}