import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/business/catalog_model.dart';
import 'dart:async';

class CatalogController extends ChangeNotifier {
  late String uidCatalog;
  late CollectionReference catalogCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, int> selectedCatalogItems = {};
  final _selectedItemsStreamController = StreamController<Map<String, int>>.broadcast();
  Stream<Map<String, int>> get selectedItemsStream => _selectedItemsStreamController.stream;

  CatalogController() {
    uidCatalog = FirebaseAuth.instance.currentUser!.uid;
    catalogCollection =
        FirebaseFirestore.instance.collection('catalog_$uidCatalog');
  }

  void toggleSelection(String productId) {
    if (selectedCatalogItems.containsKey(productId)) {
      selectedCatalogItems.remove(productId);
    } else {
      selectedCatalogItems[productId] = 1;
    }
    notifyListeners();
  }

  Future<void> addCatalogToFirestore(CatalogModel catalog) async {
    try {
      await catalogCollection.doc(catalog.id).set(
        catalog.toMap(),
      );
    } catch (error) {
      // Lida com o erro aqui.
    }
    notifyListeners();
  }

  Future<void> removeCatalogFromFirestore(String catalogId) async {
    try {
      await catalogCollection.doc(catalogId).delete();
    } catch (error) {
      // Lida com o erro aqui.
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
