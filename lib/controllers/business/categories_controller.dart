import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:iboss/models/business/categories_model.dart';

class CategoriesController extends ChangeNotifier {
  late String uidCategories;
  late CollectionReference categoriesCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CategoriesController() {
    uidCategories = FirebaseAuth.instance.currentUser!.uid;
    categoriesCollection =
        FirebaseFirestore.instance.collection('categories_$uidCategories');
  }

  Stream<List<CategoriesModel>> getCategoriesStream() {
    return categoriesCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return CategoriesModel(
              name: doc['name'],
              id: doc.id,
            );
          },
        ).toList();
      },
    );
  }

  Future<void> addCategoriesToFirestore(CategoriesModel category) async {
    try {
      await categoriesCollection.doc(category.id).set(
        category.toMap(),
      );
    } catch (error) {
      // Lida com o erro aqui.
    }
    notifyListeners();
  }

  Future<void> removeCategoriesFromFirestore(String categoryId) async {
    try {
      await categoriesCollection.doc(categoryId).delete();
    } catch (error) {
      // Lida com o erro aqui.
    }
    notifyListeners();
  }

  Stream<List<CategoriesModel>> getCategoriesFromFirestore() {
    return categoriesCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return CategoriesModel(
              name: doc['name'],
              id: doc.id,
            );
          },
        ).toList();
      },
    );
  }
}
