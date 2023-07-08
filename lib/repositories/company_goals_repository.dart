import 'package:flutter/material.dart';
import 'package:iboss/models/company_goals.dart';

class CompanyGoalsRepository extends ChangeNotifier {
  List<CompanyGoals> companyGoals = [];

  CompanyGoalsRepository ({
    required this.companyGoals
  });

  void add(CompanyGoals forCompany) {
    companyGoals.add(forCompany);
    notifyListeners();
  }

  void remove(int i) {
    companyGoals.removeAt(i);
    notifyListeners();
  }
}