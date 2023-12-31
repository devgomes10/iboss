class ExpenseModel {
  String id;
  String description;
  double value;
  bool isPaid;
  DateTime payday;
  bool isRepeat;
  int numberOfRepeats;

  ExpenseModel({required this.id,
    required this.description,
    required this.value,
    required this.isPaid,
    required this.payday,
    required this.isRepeat,
    required this.numberOfRepeats,
  });

  ExpenseModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        value = map["value"],
        isPaid = map["isPaid"],
        payday = map["payday"],
        isRepeat = map["isRepeat"],
        numberOfRepeats = map["numberOfRepeats"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "value": value,
      "isPaid": isPaid,
      "payday": payday,
      "isRepeat": isRepeat,
      "numberOfRepeats": numberOfRepeats,
    };
  }
}
