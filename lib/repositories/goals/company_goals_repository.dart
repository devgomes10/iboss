import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/goals/company_goals.dart';

class CompanyGoalsRepository extends ChangeNotifier {
  late String uidCompany;
  late CollectionReference companyCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CompanyGoalsRepository() {
    uidCompany = FirebaseAuth.instance.currentUser!.uid;
    companyCollection =
        FirebaseFirestore.instance.collection('companyGoals_$uidCompany');
  }

  Stream<List<CompanyGoals>> getCompanyGoalsStream() {
    return companyCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return CompanyGoals(
            description: doc['description'],
            date: doc['date'].toDate(),
            id: doc.id,
            isChecked: doc['isChecked'] ?? false, // Use o valor do Firestore
          );
        }).toList();
      },
    );
  }

  Future<void> updateCompanyGoalStatus(String goalId, bool isChecked) async {
    try {
      await companyCollection.doc(goalId).update({"isChecked": isChecked});
    } catch (error) {
      // Lidar com erros, se necessário
    }
  }

  Future<void> addCompanyGoalsToFirestore(CompanyGoals goals) async {
    try {
      await companyCollection.doc(goals.id).set(
        goals.toMap(),
      );
    } catch (error) {
      const Text("Erro ao adicionar meta", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
  }

  Future<void> removeGoalsFromFirestore(String goalId) async {
    try {
      await companyCollection.doc(goalId).delete();
    } catch (error) {
      const Text("Erro ao remover meta", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
  }
}