import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/business/product_model.dart';
import 'dart:async';

class ProductController extends ChangeNotifier {
  late String uidProduct;
  late CollectionReference productCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, int> selectedCatalogItems = {};
  final _selectedItemsStreamController = StreamController<Map<String, int>>.broadcast();
  Stream<Map<String, int>> get selectedItemsStream => _selectedItemsStreamController.stream;

  ProductController() {
    uidProduct = FirebaseAuth.instance.currentUser!.uid;
    productCollection =
        FirebaseFirestore.instance.collection('catalog_$uidProduct');
  }

  // double calculateTotalSelectedPrice() {
  //   double total = 0.0;
  //
  //   // Itera sobre os produtos selecionados e soma os preços
  //   selectedCatalogItems.forEach((productId, quantity) async {
  //     // Obtém o preço do produto pelo ID
  //     final selectedProduct = await catalogCollection.doc(productId).get();
  //     final price = selectedProduct['price'].toDouble();
  //
  //     // Calcula o total para o produto específico
  //     total += price * quantity;
  //   });
  //
  //   return total;
  // }

  void toggleSelection(String productId) {
    if (selectedCatalogItems.containsKey(productId)) {
      selectedCatalogItems.remove(productId);
    } else {
      selectedCatalogItems[productId] = 1;
    }
    notifyListeners();
  }

  Future<void> addProductToFirestore(ProductModel product) async {
    try {
      await productCollection.doc(product.id).set(
        product.toMap(),
      );
    } catch (error) {
      // Lida com o erro aqui.
    }
    notifyListeners();
  }

  Future<void> removeProductFromFirestore(String productId) async {
    try {
      await productCollection.doc(productId).delete();
    } catch (error) {
      // Lida com o erro aqui.
    }
    notifyListeners();
  }

  Stream<List<ProductModel>> getProductFromFirestore() {
    return productCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return ProductModel(
              id: doc.id,
              name: doc['name'],
              price: doc['price'].toDouble(),
              soldAmount: doc['soldAmount'],
            );
          },
        ).toList();
      },
    );
  }
}
