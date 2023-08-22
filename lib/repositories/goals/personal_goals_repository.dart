import 'package:flutter/material.dart';
import '../../models/goals/personal_goals.dart';


class PersonalGoalsRepository extends ChangeNotifier {
  List<PersonalGoals> personalGoals = [];

  PersonalGoalsRepository ({
    required this.personalGoals
  });

  void add(PersonalGoals personal) {
    personalGoals.add(personal);
    notifyListeners();
  }

  void remove(int i) {
    personalGoals.removeAt(i);
    notifyListeners();
  }
}