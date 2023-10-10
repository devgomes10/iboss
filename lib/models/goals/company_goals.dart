class CompanyGoals {
  String description;
  DateTime date;
  String id;
  bool isChecked;

  CompanyGoals({
    required this.description,
    required this.date,
    required this.id,
    required this.isChecked,
  });

  CompanyGoals.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        date = map["date"],
        isChecked = map["isChecked"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "date": date,
      "isChecked": isChecked,
    };
  }
}
