import 'package:flutter/material.dart';
import 'package:iboss/models/fixed_entry.dart';

class FixedEntryRepository extends ChangeNotifier {
  List<FixedEntry> fixedEntry = [];

  FixedEntryRepository ({
    required this.fixedEntry
  });

  void add(FixedEntry fixed) {
    fixedEntry.add(fixed);
    notifyListeners();
  }

  void remove(int i) {
    fixedEntry.removeAt(i);
    notifyListeners();
  }

  double getTotalFixedEntryByMonth(DateTime selectedMonth) {
    double total = 0.0;

    fixedEntry.forEach((payment) {
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