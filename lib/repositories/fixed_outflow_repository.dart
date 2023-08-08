import 'package:flutter/material.dart';
import 'package:iboss/models/fixed_outflow.dart';


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

  List<FixedOutflow> getFixedOutflowsByMonth(int month) {
    return fixedOutflow.where((fixedOutflow) => fixedOutflow.date.month == month).toList();
  }
}
