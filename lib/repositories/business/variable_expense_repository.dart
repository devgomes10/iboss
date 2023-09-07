import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/business/variable_expense.dart';

class VariableExpenseRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<VariableExpense>> getVariableExpensesStream() {
    return firestore.collection('variable_expenses').snapshots().map(
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
      await firestore.collection('variable_expenses').doc(expense.id).set(
        expense.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar pagamento ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removeExpenseFromFirestore(String expenseId) async {
    try {
      await firestore.collection('variable_expenses').doc(expenseId).delete();
    } catch (error) {
      print('Erro ao remover pagamento do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<VariableExpense>> getVariableExpensesFromFirestore() async {
    List<VariableExpense> variableExpenses = [];
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('variable_expenses').get();
      variableExpenses = querySnapshot.docs
          .map((doc) =>
          VariableExpense.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter pagamentos do Firestore: $error');
    }
    notifyListeners();
    return variableExpenses;
  }

  Stream<double> getTotalVariableExpensesByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = firestore
        .collection('variable_expenses')
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

  Stream<List<VariableExpense>> getVariableExpensesByMonth(DateTime selectedMonth) {
    return firestore
        .collection('variable_expenses')
        .where('date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
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