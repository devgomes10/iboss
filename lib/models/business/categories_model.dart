class CategoriesModel {
  String name;
  String id;

  CategoriesModel({
    required this.name,
    required this.id,
  });

  CategoriesModel.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        id = map["id"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "id": id,
    };
  }
}
