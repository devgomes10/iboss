class CompanyGoals {
  String description;
  DateTime date;
  String id;

  CompanyGoals({
    required this.description,
    required this.date,
    required this.id,
  });

  CompanyGoals.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        date = map["date"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "date": date,
    };
  }
}
