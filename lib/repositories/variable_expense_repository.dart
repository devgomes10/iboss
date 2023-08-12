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

  double getTotalVariableExpensesByMonth(DateTime selectedMonth) {
    double total = 0.0;

    variableExpenses.forEach((payment) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      if (paymentYear == selectedMonth.year &&
          paymentMonth == selectedMonth.month) {
        total += payment.value;
      }
    });
    return total;
  }

  List<VariableExpense> getVariableExpensesByMonth(DateTime selectedDate) {
    final String monthYearString = DateFormat('MM-yyyy').format(selectedDate);
    return variableExpenses.where((expense) => DateFormat('MM-yyyy').format(expense.date) == monthYearString).toList();
  }
}