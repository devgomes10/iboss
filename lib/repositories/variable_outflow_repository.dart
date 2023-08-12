import 'package:flutter/material.dart';
import 'package:iboss/models/variable_outflow.dart';
import 'package:intl/intl.dart';


class VariableOutflowRepository extends ChangeNotifier {
  List<VariableOutflow> variableOutflow = [];

  VariableOutflowRepository ({
    required this.variableOutflow
  });

  void add(VariableOutflow variable) {
    variableOutflow.add(variable);
    notifyListeners();
  }

  void remove(int i) {
    variableOutflow.removeAt(i);
    notifyListeners();
  }

  double getTotalVariableOutflowByMonth(DateTime selectedMonth) {
    double total = 0.0;

    variableOutflow.forEach((payment) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      if (paymentYear == selectedMonth.year &&
          paymentMonth == selectedMonth.month) {
        total += payment.value;
      }
    });
    return total;
  }

  List<VariableOutflow> getVariableOutflowsByMonth(DateTime selectedDate) {
    final String monthYearString = DateFormat('MM-yyyy').format(selectedDate);
    return variableOutflow.where((expense) => DateFormat('MM-yyyy').format(expense.date) == monthYearString).toList();
  }
}