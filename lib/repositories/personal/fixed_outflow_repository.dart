import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/personal/fixed_outflow.dart';

class FixedOutflowRepository extends ChangeNotifier {
  late String uidFixedOutflow;
  late CollectionReference fixedOutflowCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FixedOutflowRepository() {
    uidFixedOutflow = FirebaseAuth.instance.currentUser!.uid;
    fixedOutflowCollection =
        FirebaseFirestore.instance.collection('fixedOutflows_$uidFixedOutflow');
  }

  Stream<List<FixedOutflow>> getFixedOutflowStream() {
    return fixedOutflowCollection.snapshots().map(
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

  Future<void> addOutflowToFirestore(FixedOutflow outflow) async {
    try {
      await fixedOutflowCollection.doc(outflow.id).set(
            outflow.toMap(),
          );
    } catch (error) {
      print('Erro ao adicionar saída ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeOutflowFromFirestore(String outflowId) async {
    try {
      await fixedOutflowCollection.doc(outflowId).delete();
    } catch (error) {
      print('Erro ao remover saída do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<FixedOutflow>> getFixedOutflowFromFirestore() async {
    List<FixedOutflow> fixedOutflow = [];
    try {
      QuerySnapshot querySnapshot = await fixedOutflowCollection.get();
      fixedOutflow = querySnapshot.docs
          .map(
              (doc) => FixedOutflow.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter saídas do Firestore: $error');
    }
    notifyListeners();
    return fixedOutflow;
  }

  Stream<double> getTotalFixedOutflowByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = fixedOutflowCollection
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

  Stream<List<FixedOutflow>> getFixedOutflowByMonth(DateTime selectedMonth) {
    return fixedOutflowCollection
        .where('date',
            isGreaterThanOrEqualTo:
                DateTime(selectedMonth.year, selectedMonth.month, 1),
            isLessThan:
                DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
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
