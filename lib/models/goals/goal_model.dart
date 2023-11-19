class GoalModel {
  String id;
  String description;
  DateTime finalDate;
  double priority;
  bool isChecked;

  GoalModel({
    required this.id,
    required this.description,
    required this.finalDate,
    required this.priority,
    required this.isChecked,
  });

  GoalModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        finalDate = map["finalDate"],
        priority = map["priority"],
        isChecked = map["isChecked"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "finalDate": finalDate,
      "priority": priority,
      "isChecked": isChecked,
    };
  }
}
