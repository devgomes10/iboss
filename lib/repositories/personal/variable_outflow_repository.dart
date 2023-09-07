import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/personal/variable_outflow.dart';
import 'package:intl/intl.dart';


class VariableOutflowRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<VariableOutflow>> getVariableOutflowStream() {
    return firestore.collection('variable_outflow').snapshots().map(
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

  Future<void> addOutflowToFirestore(VariableOutflow entry) async {
    try {
      await firestore.collection('variable_outflow').doc(entry.id).set(
        entry.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar pagamento ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeOutflowFromFirestore(String outflowId) async {
    try {
      await firestore.collection('variable_outflow').doc(outflowId).delete();
    } catch (error) {
      print('Erro ao remover pagamento do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<VariableOutflow>> getVariableOutflowFromFirestore() async {
    List<VariableOutflow> variableOutflow = [];
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('variable_outflow').get();
      variableOutflow = querySnapshot.docs
          .map((doc) =>
          VariableOutflow.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter pagamentos do Firestore: $error');
    }
    notifyListeners();
    return variableOutflow;
  }

  Stream<double> getTotalVariableOutflowByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = firestore
        .collection('variable_outflow')
        .where(
        'date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots();

    return queryStream.map((querySnapshot) {
      double total = 0.0;
      for (var doc in querySnapshot.docs) {
        total += doc['value'];
      }
      return total;
    });
  }

  Stream<List<VariableOutflow>> getVariableOutflowByMonth(DateTime selectedMonth) {
    return firestore
        .collection('variable_outflow')
        .where('date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
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