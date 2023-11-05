class RevenueModel {
  String id;
  String description;
  double value;
  bool isReceived;
  DateTime receiptDate;
  int isRepeat;

  RevenueModel({
    required this.id,
    required this.description,
    required this.value,
    required this.isReceived,
    required this.receiptDate,
    required this.isRepeat,
  });

  RevenueModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        description = map["description"],
        value = map["value"],
        isReceived = map["isReceived"],
        receiptDate = map["receiptDare"],
        isRepeat = map["isRepeat"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "value": value,
      "isReceived": isReceived,
      "receiptDate": receiptDate,
      "isRepeat": isRepeat,
    };
  }
}
