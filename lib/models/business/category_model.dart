class CategoryModel {
  String name;
  String id;

  CategoryModel({
    required this.name,
    required this.id,
  });

  CategoryModel.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        id = map["id"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "id": id,
    };
  }
}
