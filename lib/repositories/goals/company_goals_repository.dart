import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/goals/company_goals.dart';

class CompanyGoalsRepository extends ChangeNotifier {
  late String uid;
  late CollectionReference companyCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CompanyGoalsRepository() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    companyCollection =
        FirebaseFirestore.instance.collection('companyGoals_$uid');
  }

  Stream<List<CompanyGoals>> getCompanyGoalsStream() {
    return companyCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return CompanyGoals(
            description: doc['description'],
            date: doc['date'].toDate(),
            id: doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> addCompanyGoalsToFirestore(CompanyGoals goals) async {
    try {
      await companyCollection.doc(goals.id).set(
        goals.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar pagamento ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeGoalsFromFirestore(String goalId) async {
    try {
      await companyCollection.doc(goalId).delete();
    } catch (error) {
      print('Erro ao remover pagamento do Firestore: $error');
    }
    notifyListeners();
  }
}