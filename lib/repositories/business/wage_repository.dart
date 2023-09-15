import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WageRepository extends ChangeNotifier {
  late String uidWage;
  late CollectionReference wageCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  WageRepository() {
    uidWage = FirebaseAuth.instance.currentUser!.uid;
    wageCollection =
        FirebaseFirestore.instance.collection('wage_$uidWage');
  }

  Future<void> updateWage(double newWage) async {
    await wageCollection.doc().set({'value': newWage});

    notifyListeners();
  }

  Future<double?> getCurrentWage() async {
    final doc = await wageCollection.doc().get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final wageValue = data['value'] as double?;
      return wageValue;
    }
    return null;
  }

}
