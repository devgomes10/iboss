import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class TransactionController extends ChangeNotifier {
  late String uidTransaction;
  late CollectionReference transactionCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TransactionController() {
    uidTransaction = FirebaseAuth.instance.currentUser!.uid;
    transactionCollection =
        FirebaseFirestore.instance.collection('transaction_$uidTransaction');
  }

  Stream<List<TransactionModel>> getTransactionStream() {
    return transactionCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            return TransactionModel(
              id: doc.id,
              isRevenue: doc["isRevenue"],
              description: doc["description"],
              value: doc["value"],
              isCompleted: doc["isCompleted"],
              transactionDate: doc["transactionDate"].toDate(),
              isRepeat: doc["isRepeat"],
              numberOfRepeats: doc["numberOfRepeats"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> addTransactionToFirestore(TransactionModel transaction) async {
    try {
      await transactionCollection.doc(transaction.id).set(
        transaction.toMap(),
      );
    } catch (error) {
      // tratar em caso de erro
    }
    notifyListeners();
  }

  Future<void> removeTransactionFromFirestore(String transactionId) async {
    try {
      await transactionCollection.doc(transactionId).delete();
    } catch (error) {
      // tratar em caso de erro
    }
    notifyListeners();
  }

  Future<List<TransactionModel>> getTransactionFromFirestore() async {
    List<TransactionModel> trasactions = [];
    try {
      QuerySnapshot querySnapshot = await transactionCollection.get();
      trasactions = querySnapshot.docs
          .map((doc) =>
          TransactionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      // tratar em caso de erro
    }
    return trasactions;
  }

  Stream<List<TransactionModel>> getTransactionByMonth(DateTime selectedMonth) {
    return transactionCollection
        .where('transactionDate',
        isGreaterThanOrEqualTo:
        DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan:
        DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return TransactionModel(
          id: doc.id,
          isRevenue: doc["isRevenue"],
          description: doc["description"],
          value: doc["value"],
          isCompleted: doc["isCompleted"],
          transactionDate: doc["transactionDate"].toDate(),
          isRepeat: doc["isRepeat"],
          numberOfRepeats: doc["numberOfRepeats"],
        );
      }).toList();
    });
  }

  Future<void> updateTransactionInFirestore(TransactionModel updatedTransaction) async {
    try {
      final doc = await transactionCollection.doc(updatedTransaction.id).get();
      if (doc.exists) {
        await transactionCollection
            .doc(updatedTransaction.id)
            .update(updatedTransaction.toMap());
      } else {
        // tratar em caso de erro
      }
    } catch (error) {
      // tratar em caso de erro
    }
    notifyListeners();
  }

  Future<void> updateStatus(String transactionId, String field, dynamic value) async {
    try {
      Map<String, dynamic> dataToUpdate = {field: value};
      await transactionCollection.doc(transactionId).update(dataToUpdate);
    } catch (error) {
      // tratar em caso de erro
    }
  }
}

