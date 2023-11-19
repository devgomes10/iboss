import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/goals/goal_model.dart';

class GoalController extends ChangeNotifier {
  late String uidGoal;
  late CollectionReference goalsCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  GoalController() {
    uidGoal = FirebaseAuth.instance.currentUser!.uid;
    goalsCollection = FirebaseFirestore.instance.collection('goal_$uidGoal');
  }

  Stream<List<GoalModel>> getGoalsStream() {
    return goalsCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return GoalModel(
            id: doc.id,
            description: doc['description'],
            finalDate: doc['finalDate'].toDate(),
            priority: doc['priority'],
            isChecked: doc['isChecked'],
          );
        }).toList();
      },
    );
  }

  Future<void> updateGoalStatus(String goalId, bool isChecked) async {
    try {
      await goalsCollection.doc(goalId).update({"isChecked": isChecked});
    } catch (error) {
      // Lidar com erros, se necessário
    }
  }

  Future<void> addGoalToFirestore(GoalModel goal) async {
    try {
      await goalsCollection.doc(goal.id).set(
            goal.toMap(),
          );
    } catch (error) {
      // Lidar com erros, se necessário
    }
  }

  Future<void> removeGoalFromFirestore(String goalId) async {
    try {
      await goalsCollection.doc(goalId).delete();
    } catch (error) {
      // Lidar com erros, se necessário
    }
  }
}
