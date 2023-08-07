import 'package:flutter/material.dart';
import 'package:iboss/models/variable_expense.dart';
import 'package:intl/intl.dart';


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

  List<VariableExpense> getVariableExpensesByMonth(DateTime selectedDate) {
    final String monthYearString = DateFormat('MM-yyyy').format(selectedDate);
    return variableExpenses.where((expense) => DateFormat('MM-yyyy').format(expense.date) == monthYearString).toList();
  }
}