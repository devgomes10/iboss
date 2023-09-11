import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/personal/variable_entry.dart';

class VariableEntryRepository extends ChangeNotifier {
  late String uid;
  late CollectionReference variableEntryCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  VariableEntryRepository() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    variableEntryCollection =
        FirebaseFirestore.instance.collection('variableEntries_$uid');
  }

  Stream<List<VariableEntry>> getVariableEntryStream() {
    return variableEntryCollection.snapshots().map(
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
      await variableEntryCollection.doc(entry.id).set(
        entry.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar entrada ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeEntryFromFirestore(String entryId) async {
    try {
      await variableEntryCollection.doc(entryId).delete();
    } catch (error) {
      print('Erro ao remover entrada do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<VariableEntry>> getVariableEntryFromFirestore() async {
    List<VariableEntry> variableEntry = [];
    try {
      QuerySnapshot querySnapshot =
      await variableEntryCollection.get();
      variableEntry = querySnapshot.docs
          .map((doc) =>
          VariableEntry.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter entradas do Firestore: $error');
    }
    notifyListeners();
    return variableEntry;
  }

  Stream<double> getTotalVariableEntryByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = variableEntryCollection
        .where(
        'date',
        isGreaterThanOrEqualTo:
        DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(
            selectedMonth.year, selectedMonth.month + 1, 1))
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
    return variableEntryCollection
        .where('date',
        isGreaterThanOrEqualTo:
        DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(
            selectedMonth.year, selectedMonth.month + 1, 1))
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
