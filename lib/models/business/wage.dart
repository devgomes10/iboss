class Wage {
  double value;
  String id;

  Wage ({
    required this.value,
    required this.id,
  });

  Wage.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        value = map["value"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "value": value,
    };
  }
}