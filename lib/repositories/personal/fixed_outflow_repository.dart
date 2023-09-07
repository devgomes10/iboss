import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/personal/variable_outflow.dart';
import 'package:intl/intl.dart';
import '../../models/personal/fixed_outflow.dart';


class FixedOutflowRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<FixedOutflow>> getFixedOutflowStream() {
    return firestore.collection('fixed_outflow').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return FixedOutflow(
            description: doc['description'],
            value: doc['value'],
            date: doc['date'].toDate(),
            id: doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> addOutflowToFirestore(FixedOutflow entry) async {
    try {
      await firestore.collection('fixed_outflow').doc(entry.id).set(
        entry.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar pagamento ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeOutflowFromFirestore(String outflowId) async {
    try {
      await firestore.collection('fixed_outflow').doc(outflowId).delete();
    } catch (error) {
      print('Erro ao remover pagamento do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<FixedOutflow>> getFixedOutflowFromFirestore() async {
    List<FixedOutflow> fixedOutflow = [];
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('fixed_outflow').get();
      fixedOutflow = querySnapshot.docs
          .map((doc) =>
          FixedOutflow.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter pagamentos do Firestore: $error');
    }
    notifyListeners();
    return fixedOutflow;
  }

  Stream<double> getTotalFixedOutflowByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = firestore
        .collection('fixed_outflow')
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

  Stream<List<FixedOutflow>> getFixedOutflowByMonth(DateTime selectedMonth) {
    return firestore
        .collection('fixed_outflow')
        .where('date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return FixedOutflow(
          description: doc['description'],
          value: doc['value'],
          date: doc['date'].toDate(),
          id: doc.id,
        );
      }).toList();
    });
  }
}
