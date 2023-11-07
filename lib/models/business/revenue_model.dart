class RevenueModel {
  String id;
  String description;
  double value;
  bool isReceived;
  DateTime receiptDate;
  bool isRepeat;
  int numberOfRepeats;

  RevenueModel({
    required this.id,
    required this.description,
    required this.value,
    required this.isReceived,
    required this.receiptDate,
    required this.isRepeat,
    required this.numberOfRepeats,
  });

  RevenueModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        value = map["value"],
        isReceived = map["isReceived"],
        receiptDate = map["receiptDare"],
        isRepeat = map["isRepeat"],
        numberOfRepeats = map["numberOfRepeats"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "value": value,
      "isReceived": isReceived,
      "receiptDate": receiptDate,
      "isRepeat": isRepeat,
      "numberOfRepeats": numberOfRepeats,
    };
  }
}
