class EnterpriseEmergencyReserve {
  double value;
  String id;

  EnterpriseEmergencyReserve ({
    required this.value,
    required this.id,
  });

  EnterpriseEmergencyReserve.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        value = map["value"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "value": value,
    };
  }
}