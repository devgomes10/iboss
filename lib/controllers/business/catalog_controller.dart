import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/business/catalog_model.dart';

class CatalogController extends ChangeNotifier {
  late String uidCatalog;
  late CollectionReference catalogCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int totalSelectedItems = 0;
  Map<String, int> selectedCatalogItems = {};
  CatalogController() {
    uidCatalog = FirebaseAuth.instance.currentUser!.uid;
    catalogCollection =
        FirebaseFirestore.instance.collection('catalog_$uidCatalog');
  }

  void updateTotalSelectedItems(List<CatalogModel> catalogs) {
  double total = 0.0;
  selectedCatalogItems.forEach((id, quantity) {
  final catalog = catalogs.firstWhere((catalog) => catalog.id == id);
  total += catalog.price * quantity;
  });
  totalSelectedItems = total.toInt();
  }


  Stream<List<CatalogModel>> getCatalogStream() {
    return catalogCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return CatalogModel(
              name: doc['name'],
              price: doc['price'],
              id: doc.id,
            );
          },
        ).toList();
      },
    );
  }

  Future<void> addCatalogToFirestore(CatalogModel catalog) async {
    try {
      await catalogCollection.doc(catalog.id).set(
            catalog.toMap(),
          );
    } catch (error) {
      const Text(
        "erro ao adicionar produto/serviço",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
  }

  Future<void> removeCatalogFromFirestore(String catalogId) async {
    try {
      await catalogCollection.doc(catalogId).delete();
    } catch (error) {
      const Text(
        "erro ao remover produto/serviço",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
  }

  Stream<List<CatalogModel>> getCatalogFromFirestore() {
    return catalogCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return CatalogModel(
              name: doc['name'],
              price: doc['price'].toDouble(),
              id: doc.id,
            );
          },
        ).toList();
      },
    );
  }
}
