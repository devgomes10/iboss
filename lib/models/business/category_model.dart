import 'package:flutter/material.dart';

class CategoryModel {
  String id;
  String name;
  // Color color;
  double budget;

  CategoryModel({
    required this.id,
    required this.name,
    // required this.color,
    required this.budget,
  });

  CategoryModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        // color = map["color"],
        budget = map["budget"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      // "color": color,
      "budget": budget,
    };
  }
}
