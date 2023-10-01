import 'package:flutter/material.dart';
import 'package:iboss/models/goals/company_goals.dart';
import 'package:iboss/models/goals/personal_goals.dart';

class GoalsState extends ChangeNotifier {
  List<CompanyGoals> companyGoals = [];
  List<PersonalGoals> personalGoals = [];

  // Método para atualizar as metas da empresa no estado
  void updateCompanyGoals(List<CompanyGoals> goals) {
    companyGoals = goals;
    notifyListeners();
  }

  // Métodos para adicionar e remover metas das listas e atualizar o estado
  void addCompanyGoal(CompanyGoals goal) {
    companyGoals.add(goal);
    notifyListeners();
  }

  void removeCompanyGoal(String goalId) {
    companyGoals.removeWhere((goal) => goal.id == goalId);
    notifyListeners();
  }

  void addPersonalGoal(PersonalGoals goal) {
    personalGoals.add(goal);
    notifyListeners();
  }

  void removePersonalGoal(String goalId) {
    personalGoals.removeWhere((goal) => goal.id == goalId);
    notifyListeners();
  }
}
