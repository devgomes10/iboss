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
}