class ExpenseModel {
  String id;
  String description;
  double value;
  bool isPaid;
  DateTime payday;
  String category;
  int isRepeat;

  ExpenseModel(
      {required this.id,
      required this.description,
      required this.value,
      required this.isPaid,
      required this.payday,
      required this.category,
      required this.isRepeat});

  ExpenseModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        value = map["value"],
        isPaid = map["isPaid"],
        payday = map["payday"],
        category = map["category"],
        isRepeat = map["isRepeat"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "value": value,
      "isPaid": isPaid,
      "payday": payday,
      "category": category,
      "isRepeat": isRepeat,
    };
  }
}
