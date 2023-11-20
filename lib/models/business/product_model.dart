class ProductModel {
  String id;
  String name;
  double price;
  int soldAmount;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.soldAmount,
  });

  ProductModel.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        price = map["price"],
        soldAmount = map["soldAmount"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "soldAmount": soldAmount,
    };
  }
}
