class FixedExpense {
  String description;
  double value;
  DateTime date;
  String id;
  bool isPaid;
  String category;

  FixedExpense ({
    required this.description,
    required this.value,
    required this.date,
    required this.id,
    required this.isPaid,
    required this.category,
  });

  FixedExpense.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        value = map["value"],
        date = map["date"],
        isPaid = map["isPaid"],
        category = map["category"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "value": value,
      "date": date,
      "isPaid": isPaid,
      "category": category,
    };
  }
}