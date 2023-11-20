import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:iboss/models/business/category_model.dart';

class CategoryController extends ChangeNotifier {
  late String uidCategory;
  late CollectionReference categoryCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CategoryController() {
    uidCategory = FirebaseAuth.instance.currentUser!.uid;
    categoryCollection =
        FirebaseFirestore.instance.collection('category_$uidCategory');
  }

  Stream<List<CategoryModel>> getCategoryStream() {
    return categoryCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return CategoryModel(
              id: doc.id,
              name: doc['name'],
              // color: doc['color'],
              budget: doc['budget'],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> addCategoryToFirestore(CategoryModel category) async {
    try {
      await categoryCollection.doc(category.id).set(
            category.toMap(),
          );
    } catch (error) {
      // Lida com o erro aqui.
    }
    notifyListeners();
  }

  Future<void> removeCategoryFromFirestore(String categoryId) async {
    try {
      await categoryCollection.doc(categoryId).delete();
    } catch (error) {
      // Lida com o erro aqui.
    }
    notifyListeners();
  }

  Stream<List<CategoryModel>> getCategoryFromFirestore() {
    return categoryCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return CategoryModel(
              id: doc.id,
              name: doc['name'],
              // color: doc['color'],
              budget: doc['budget'],
            );
          },
        ).toList();
      },
    );
  }
}
