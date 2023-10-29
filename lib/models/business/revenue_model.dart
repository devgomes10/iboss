class RevenueModel {
  String description;
  double value;
  bool isReceived;
  DateTime receiptDate;

  // Catalog Catalog;
  bool isRepeat;
  DateTime dateNow;
  String id;

  RevenueModel({
    required this.description,
    required this.value,
    required this.isReceived,
    required this.receiptDate,
    // required this.catalog,
    required this.isRepeat,
    required this.dateNow,
    required this.id,
  });

  RevenueModel.fromMap(Map<String, dynamic> map)
      : description = map["description"],
        value = map["value"],
        isReceived = map["isReceived"],
        receiptDate = map["receiptDare"],
        // catalog = map["catalog"],
        isRepeat = map["isRepeat"],
        dateNow = map["dateNow"],
        id = map["id"];

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "value": value,
      "isReceived": isReceived,
      "receiptDate": receiptDate,
      // "catalog": catalog,
      "isRepeat": isRepeat,
      "dateNow": dateNow,
      "id": id,
    };
  }
}
