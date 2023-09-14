class OpportunityReserve {
  double value;
  String id;

  OpportunityReserve ({
    required this.value,
    required this.id,
  });

  OpportunityReserve.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        value = map["value"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "value": value,
    };
  }
}