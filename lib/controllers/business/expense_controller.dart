import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/business/expense_model.dart';

class ExpenseController extends ChangeNotifier {
  late String uid;
  late CollectionReference expenseCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ExpenseController() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    expenseCollection = FirebaseFirestore.instance.collection('expense_$uid');
  }

  Stream<List<ExpenseModel>> getExpensesStream() {
    return expenseCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return ExpenseModel(
            id: doc.id,
            description: doc['description'],
            value: doc['value'],
            isPaid: doc['isPaid'],
            payday: doc['payday'].toDate(),
            isRepeat: doc['isRepeat'],
            numberOfRepeats: doc["numberOfRepeats"],
          );
        }).toList();
      },
    );
  }

  Future<void> addExpenseToFirestore(ExpenseModel expense) async {
    try {
      await expenseCollection.doc(expense.id).set(
            expense.toMap(),
          );
    } catch (error) {
      const Text(
        "Erro ao adicionar despesa",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
  }

  Future<void> removeExpenseFromFirestore(String expenseId) async {
    try {
      await expenseCollection.doc(expenseId).delete();
    } catch (error) {
      const Text(
        "Erro ao remover despesa",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
  }

  Future<List<ExpenseModel>> getExpenseFromFirestore() async {
    List<ExpenseModel> expenses = [];
    try {
      QuerySnapshot querySnapshot = await expenseCollection.get();
      expenses = querySnapshot.docs
          .map(
              (doc) => ExpenseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      const Text(
        "Erro ao carregar dados",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
    return expenses;
  }

  Stream<double> getTotalExpensesByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = expenseCollection
        .where('payday',
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

  Stream<List<ExpenseModel>> getExpensesByMonth(DateTime selectedMonth) {
    return expenseCollection
        .where(
          'payday',
          isGreaterThanOrEqualTo:
              DateTime(selectedMonth.year, selectedMonth.month, 1),
          isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1),
        )
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ExpenseModel(
          id: doc.id,
          description: doc['description'],
          value: doc['value'],
          isPaid: doc['isPaid'],
          payday: doc['payday'].toDate(),
          isRepeat: doc['isRepeat'],
          numberOfRepeats: doc["numberOfRepeats"],
        );
      }).toList();
    });
  }

  Future<void> updateExpenseStatus(String expenseId, bool isPaid) async {
    try {
      await expenseCollection.doc(expenseId).update({"isPaid": isPaid});
    } catch (error) {
      // Lidar com erros, se necessário
    }
  }
}
