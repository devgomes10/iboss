import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iboss/models/personal/fixed_entry.dart';

class FixedEntryRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<FixedEntry>> getFixedEntryStream() {
    return firestore.collection('fixed_entry').snapshots().map(
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
      await firestore.collection('fixed_entry').doc(entry.id).set(
        entry.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar pagamento ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeEntryFromFirestore(String entryId) async {
    try {
      await firestore.collection('fixed_entry').doc(entryId).delete();
    } catch (error) {
      print('Erro ao remover pagamento do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<FixedEntry>> getFixedEntryFromFirestore() async {
    List<FixedEntry> fixedEntry = [];
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('fixed_entry').get();
      fixedEntry = querySnapshot.docs
          .map((doc) =>
          FixedEntry.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter pagamentos do Firestore: $error');
    }
    notifyListeners();
    return fixedEntry;
  }

  Stream<double> getTotalFixedEntryByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = firestore
        .collection('fixed_entry')
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

  Stream<List<FixedEntry>> getFixedEntryByMonth(DateTime selectedMonth) {
    return firestore
        .collection('fixed_entry')
        .where('date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
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