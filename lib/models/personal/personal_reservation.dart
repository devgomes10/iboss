class PersonalReservation {
  double value;
  String id;

  PersonalReservation ({
    required this.value,
    required this.id,
  });

  PersonalReservation.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        value = map["value"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "value": value,
    };
  }
}