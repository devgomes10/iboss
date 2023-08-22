import 'package:flutter/material.dart';
import '../../models/personal/variable_entry.dart';

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

    for (var payment in variableEntry) {
      final paymentYear = payment.date.year;
      final paymentMonth = payment.date.month;
      if (paymentYear == selectedMonth.year &&
          paymentMonth == selectedMonth.month) {
        total += payment.value;
      }
    }
    return total;
  }
}