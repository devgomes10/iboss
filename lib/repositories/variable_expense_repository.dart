import 'package:flutter/material.dart';
import 'package:iboss/models/variable_expense.dart';


class VariableExpenseRepository extends ChangeNotifier {
  List<VariableExpense> variableExpenses = [];

  VariableExpenseRepository ({
    required this.variableExpenses
  });

  void add(VariableExpense variable) {
    variableExpenses.add(variable);
    notifyListeners();
  }

  void remove(int i) {
    variableExpenses.removeAt(i);
    notifyListeners();
  }
}