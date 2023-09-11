import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/business/variable_expense.dart';

class VariableExpenseRepository extends ChangeNotifier {
  late String uid;
  late CollectionReference variableExpenseCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  VariableExpenseRepository() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    variableExpenseCollection = FirebaseFirestore.instance.collection('variableExpenses_$uid');
  }

  Stream<List<VariableExpense>> getVariableExpensesStream() {
    return variableExpenseCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return VariableExpense(
            description: doc['description'],
            value: doc['value'],
            date: doc['date'].toDate(),
            id: doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> addExpenseToFirestore(VariableExpense expense) async {
    try {
      await variableExpenseCollection.doc(expense.id).set(
        expense.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar despesa ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeExpenseFromFirestore(String expenseId) async {
    try {
      await variableExpenseCollection.doc(expenseId).delete();
    } catch (error) {
      print('Erro ao remover despesa do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<VariableExpense>> getVariableExpensesFromFirestore() async {
    List<VariableExpense> variableExpenses = [];
    try {
      QuerySnapshot querySnapshot =
      await variableExpenseCollection.get();
      variableExpenses = querySnapshot.docs
          .map((doc) =>
          VariableExpense.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter despesas do Firestore: $error');
    }
    notifyListeners();
    return variableExpenses;
  }

  Stream<double> getTotalVariableExpensesByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = variableExpenseCollection
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

  Stream<List<VariableExpense>> getVariableExpensesByMonth(DateTime selectedMonth) {
    return variableExpenseCollection
        .where('date',
        isGreaterThanOrEqualTo:
        DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(
            selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return VariableExpense(
          description: doc['description'],
          value: doc['value'],
          date: doc['date'].toDate(),
          id: doc.id,
        );
      }).toList();
    });
  }
}
