import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/personal/variable_entry.dart';

class VariableEntryRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<VariableEntry>> getVariableEntryStream() {
    return firestore.collection('variable_entry').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return VariableEntry(
            description: doc['description'],
            value: doc['value'],
            date: doc['date'].toDate(),
            id: doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> addEntryToFirestore(VariableEntry entry) async {
    try {
      await firestore.collection('variable_entry').doc(entry.id).set(
        entry.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar pagamento ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeEntryFromFirestore(String entryId) async {
    try {
      await firestore.collection('variable_entry').doc(entryId).delete();
    } catch (error) {
      print('Erro ao remover pagamento do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<VariableEntry>> getVariableEntryFromFirestore() async {
    List<VariableEntry> variableEntry = [];
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('variable_entry').get();
      variableEntry = querySnapshot.docs
          .map((doc) =>
          VariableEntry.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter pagamentos do Firestore: $error');
    }
    notifyListeners();
    return variableEntry;
  }

  Stream<double> getTotalVariableEntryByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = firestore
        .collection('variable_entry')
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

  Stream<List<VariableEntry>> getVariableEntryByMonth(DateTime selectedMonth) {
    return firestore
        .collection('variable_entry')
        .where('date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return VariableEntry(
          description: doc['description'],
          value: doc['value'],
          date: doc['date'].toDate(),
          id: doc.id,
        );
      }).toList();
    });
  }
}