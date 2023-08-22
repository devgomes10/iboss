import 'package:flutter/material.dart';
import 'package:iboss/models/business/wage.dart';


class WageRepository extends ChangeNotifier {
  List<Wage> salary = [];

  WageRepository ({
    required this.salary
  });

  void add(Wage bossSalary) {
    salary.add(bossSalary);
    notifyListeners();
  }

  void remove(int i) {
    salary.removeAt(i);
    notifyListeners();
  }
}