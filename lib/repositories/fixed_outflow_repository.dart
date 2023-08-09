import 'package:flutter/material.dart';
import 'package:iboss/models/fixed_outflow.dart';
import 'package:intl/intl.dart';


class FixedOutflowRepository extends ChangeNotifier {
  List<FixedOutflow> fixedOutflow = [];

  FixedOutflowRepository ({
    required this.fixedOutflow
  });

  void add(FixedOutflow fixed) {
    fixedOutflow.add(fixed);
    notifyListeners();
  }

  void remove(int i) {
    fixedOutflow.removeAt(i);
    notifyListeners();
  }

  List<FixedOutflow> getFixedOutflowsByMonth(DateTime selectedDate) {
    final String monthYearString = DateFormat('MM-yyyy').format(selectedDate);
    return fixedOutflow.where((expense) => DateFormat('MM-yyyy').format(expense.date) == monthYearString).toList();
  }
}
