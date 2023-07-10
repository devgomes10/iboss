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
}