class CategoryModel {
  String id;
  String name;
  double budget;

  CategoryModel({
    required this.id,
    required this.name,
    required this.budget,
  });

  CategoryModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        budget = map["budget"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "budget": budget,
    };
  }
}
