import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/business/fixed_expense.dart';

class FixedExpenseRepository extends ChangeNotifier {
  late String uid;
  late CollectionReference fixedExpenseCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FixedExpenseRepository() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    fixedExpenseCollection = FirebaseFirestore.instance.collection('fixedExpenses_$uid');
  }

  Stream<List<FixedExpense>> getFixedExpensesStream() {
    return fixedExpenseCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return FixedExpense(
            description: doc['description'],
            value: doc['value'],
            date: doc['date'].toDate(),
            id: doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> addExpenseToFirestore(FixedExpense expense) async {
    try {
      await fixedExpenseCollection.doc(expense.id).set(
        expense.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar despesa ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeExpenseFromFirestore(String expenseId) async {
    try {
      await fixedExpenseCollection.doc(expenseId).delete();
    } catch (error) {
      print('Erro ao remover despesa do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<FixedExpense>> getFixedExpensesFromFirestore() async {
    List<FixedExpense> fixedExpenses = [];
    try {
      QuerySnapshot querySnapshot =
      await fixedExpenseCollection.get();
      fixedExpenses = querySnapshot.docs
          .map((doc) =>
          FixedExpense.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter despesas do Firestore: $error');
    }
    notifyListeners();
    return fixedExpenses;
  }

  Stream<double> getTotalFixedExpensesByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = fixedExpenseCollection
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

  Stream<List<FixedExpense>> getFixedExpensesByMonth(DateTime selectedMonth) {
    return fixedExpenseCollection
        .where('date',
        isGreaterThanOrEqualTo:
        DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(
            selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return FixedExpense(
          description: doc['description'],
          value: doc['value'],
          date: doc['date'].toDate(),
          id: doc.id,
        );
      }).toList();
    });
  }
}
