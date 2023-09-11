import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/personal/fixed_entry.dart';

class FixedEntryRepository extends ChangeNotifier {
  late String uid;
  late CollectionReference fixedEntryCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FixedEntryRepository() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    fixedEntryCollection = FirebaseFirestore.instance.collection('fixedEntries_$uid');
  }

  Stream<List<FixedEntry>> getFixedEntryStream() {
    return fixedEntryCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return FixedEntry(
            description: doc['description'],
            value: doc['value'],
            date: doc['date'].toDate(),
            id: doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> addEntryToFirestore(FixedEntry entry) async {
    try {
      await fixedEntryCollection.doc(entry.id).set(
        entry.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar entrada ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeEntryFromFirestore(String entryId) async {
    try {
      await fixedEntryCollection.doc(entryId).delete();
    } catch (error) {
      print('Erro ao remover entrada do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<FixedEntry>> getFixedEntryFromFirestore() async {
    List<FixedEntry> fixedEntry = [];
    try {
      QuerySnapshot querySnapshot =
      await fixedEntryCollection.get();
      fixedEntry = querySnapshot.docs
          .map((doc) =>
          FixedEntry.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter entradas do Firestore: $error');
    }
    notifyListeners();
    return fixedEntry;
  }

  Stream<double> getTotalFixedEntryByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = fixedEntryCollection
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

  Stream<List<FixedEntry>> getFixedEntryByMonth(DateTime selectedMonth) {
    return fixedEntryCollection
        .where('date',
        isGreaterThanOrEqualTo:
        DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(
            selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return FixedEntry(
          description: doc['description'],
          value: doc['value'],
          date: doc['date'].toDate(),
          id: doc.id,
        );
      }).toList();
    });
  }
}
