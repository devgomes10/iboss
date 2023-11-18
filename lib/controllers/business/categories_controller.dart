import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:iboss/models/business/category_model.dart';

class CategoriesController extends ChangeNotifier {
  late String uidCategories;
  late CollectionReference categoriesCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CategoriesController() {
    uidCategories = FirebaseAuth.instance.currentUser!.uid;
    categoriesCollection =
        FirebaseFirestore.instance.collection('categories_$uidCategories');
  }

  Stream<List<CategoryModel>> getCategoriesStream() {
    return categoriesCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return CategoryModel(
              name: doc['name'],
              id: doc.id,
            );
          },
        ).toList();
      },
    );
  }

  Future<void> addCategoriesToFirestore(CategoryModel category) async {
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

  Stream<List<CategoryModel>> getCategoriesFromFirestore() {
    return categoriesCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return CategoryModel(
              name: doc['name'],
              id: doc.id,
            );
          },
        ).toList();
      },
    );
  }
}
