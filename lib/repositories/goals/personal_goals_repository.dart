import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/goals/personal_goals.dart';

class PersonalGoalsRepository extends ChangeNotifier {
  late String uidPersonal;
  late CollectionReference personalCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  PersonalGoalsRepository() {
    uidPersonal = FirebaseAuth.instance.currentUser!.uid;
    personalCollection =
        FirebaseFirestore.instance.collection('personalGoals_$uidPersonal');
  }

  Stream<List<PersonalGoals>> getPersonalGoalsStream() {
    return personalCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return PersonalGoals(
            description: doc['description'],
            date: doc['date'].toDate(),
            id: doc.id,
            isChecked: doc['isChecked'] ?? false, // Use o valor do Firestore
          );
        }).toList();
      },
    );
  }

  Future<void> updatePerosnalGoalStatus(String goalId, bool isChecked) async {
    try {
      await personalCollection.doc(goalId).update({"isChecked": isChecked});
    } catch (error) {
      // Lidar com erros, se necessário
    }
  }

  Future<void> addPersonalGoalsToFirestore(PersonalGoals goalsPersonal) async {
    try {
      await personalCollection.doc(goalsPersonal.id).set(
        goalsPersonal.toMap(),
      );
    } catch (error) {
      const Text("Erro ao adicionar meta", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
  }

  Future<void> removeGoalsFromFirestore(String goalId) async {
    try {
      await personalCollection.doc(goalId).delete();
    } catch (error) {
      const Text("Erro ao remover meta", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
  }
}