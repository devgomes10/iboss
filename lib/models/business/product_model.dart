class ProductModel {
  String name;
  double price;
  String id;

  ProductModel({
    required this.name,
    required this.price,
    required this.id,
  });

  ProductModel.fromMap(Map<String, dynamic> map)
      : name = map["name"],
        price = map["price"],
        id = map["id"];

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "id": id,
    };
  }
}
