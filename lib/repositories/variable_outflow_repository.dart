import 'package:flutter/material.dart';
import 'package:iboss/models/variable_outflow.dart';


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
}