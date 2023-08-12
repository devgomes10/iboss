import 'package:flutter/material.dart';
import 'package:iboss/models/variable_entry.dart';

class VariableEntryRepository extends ChangeNotifier {
  List<VariableEntry> variableEntry = [];

  VariableEntryRepository ({
    required this.variableEntry
  });

  void add(VariableEntry variable) {
    variableEntry.add(variable);
    notifyListeners();
  }

  void remove(int i) {
    variableEntry.removeAt(i);
    notifyListeners();
  }

  double getTotalVariableEntryByMonth(DateTime selectedMonth) {
    double total = 0.0;

    variableEntry.forEach((payment) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      if (paymentYear == selectedMonth.year &&
          paymentMonth == selectedMonth.month) {
        total += payment.value;
      }
    });
    return total;
  }
}