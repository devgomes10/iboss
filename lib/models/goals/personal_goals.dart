class PersonalGoals {
  String description;
  DateTime date;
  String id;

  PersonalGoals({
    required this.description,
    required this.date,
    required this.id,
  });

  PersonalGoals.fromMap(Map<String, dynamic> map)
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
