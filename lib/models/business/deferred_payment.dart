class DeferredPayment {
  String description;
  double value;
  DateTime date;
  String id;

  DeferredPayment ({
    required this.description,
    required this.value,
    required this.date,
    required this.id,
  });

  DeferredPayment.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        value = map["value"],
        date = map["date"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "value": value,
      "date": date,
    };
  }
}