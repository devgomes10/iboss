class VariableExpense {
  String description;
  double value;
  DateTime date;
  String id;
  bool isPaid;

  VariableExpense ({
    required this.description,
    required this.value,
    required this.date,
    required this.id,
    required this.isPaid,
  });

  VariableExpense.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        value = map["value"],
        date = map["date"],
        isPaid = map["isPaid"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "value": value,
      "date": date,
      "isPaid": isPaid,
    };
  }
}