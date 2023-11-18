import 'package:cloud_firestore/cloud_firestore.dart';
import 'business/category_model.dart';

class TransactionModel {
  String id;
  bool isRevenue;
  String description;
  double value;
  bool isCompleted;
  DateTime transactionDate;
  CategoryModel? category;
  bool isRepeat;
  int numberOfRepeats;

  TransactionModel({
    required this.id,
    required this.isRevenue,
    required this.description,
    required this.value,
    required this.isCompleted,
    required this.transactionDate,
    this.category,
    required this.isRepeat,
    required this.numberOfRepeats,
  });

  TransactionModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        isRevenue = map["isRevenue"],
        description = map["description"],
        value = map["value"],
        isCompleted = map["isCompleted"],
        transactionDate = (map["transactionDate"] as Timestamp).toDate(),
        category = map.containsKey("category")
            ? CategoryModel.fromMap(map["category"] as Map<String, dynamic>)
            : null,
        isRepeat = map["isRepeat"],
        numberOfRepeats = map["numberOfRepeats"];


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "isRevenue": isRevenue,
      "description": description,
      "value": value,
      "isCompleted": isCompleted,
      "transactionDate": transactionDate,
      "isRepeat": isRepeat,
      "numberOfRepeats": numberOfRepeats,
    };

    // Adiciona o campo 'category' ao mapa somente se não for nulo
    if (category != null) {
      map["category"] = category!.toMap(); // Ou ajuste de acordo com a estrutura de CategoryModel
    }

    return map;
  }
}
