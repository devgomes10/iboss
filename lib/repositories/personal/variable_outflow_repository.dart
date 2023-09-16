import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/personal/variable_outflow.dart';

class VariableOutflowRepository extends ChangeNotifier {
  late String uidVariableOutflow;
  late CollectionReference variableOutflowCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  VariableOutflowRepository() {
    uidVariableOutflow = FirebaseAuth.instance.currentUser!.uid;
    variableOutflowCollection = FirebaseFirestore.instance
        .collection('variableOutflows_$uidVariableOutflow');
  }

  Stream<List<VariableOutflow>> getVariableOutflowStream() {
    return variableOutflowCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return VariableOutflow(
            description: doc['description'],
            value: doc['value'],
            date: doc['date'].toDate(),
            id: doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> addOutflowToFirestore(VariableOutflow outflow) async {
    try {
      await variableOutflowCollection.doc(outflow.id).set(
            outflow.toMap(),
          );
    } catch (error) {
      Text("Erro ao adicionar gasto", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
  }

  Future<void> removeOutflowFromFirestore(String outflowId) async {
    try {
      await variableOutflowCollection.doc(outflowId).delete();
    } catch (error) {
      Text("Erro ao remover gasto", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
  }

  Future<List<VariableOutflow>> getVariableOutflowFromFirestore() async {
    List<VariableOutflow> variableOutflow = [];
    try {
      QuerySnapshot querySnapshot = await variableOutflowCollection.get();
      variableOutflow = querySnapshot.docs
          .map((doc) =>
              VariableOutflow.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      Text("Erro ao carregar dados", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
    return variableOutflow;
  }

  Stream<double> getTotalVariableOutflowByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = variableOutflowCollection
        .where('date',
            isGreaterThanOrEqualTo:
                DateTime(selectedMonth.year, selectedMonth.month, 1),
            isLessThan:
                DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots();

    return queryStream.map((querySnapshot) {
      double total = 0.0;
      for (var doc in querySnapshot.docs) {
        total += doc['value'];
      }
      return total;
    });
  }

  Stream<List<VariableOutflow>> getVariableOutflowByMonth(
      DateTime selectedMonth) {
    return variableOutflowCollection
        .where('date',
            isGreaterThanOrEqualTo:
                DateTime(selectedMonth.year, selectedMonth.month, 1),
            isLessThan:
                DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return VariableOutflow(
          description: doc['description'],
          value: doc['value'],
          date: doc['date'].toDate(),
          id: doc.id,
        );
      }).toList();
    });
  }
}
