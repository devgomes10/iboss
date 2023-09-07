import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/business/deferred_payment.dart';

class DeferredPaymentRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<DeferredPayment>> getDeferredPaymentsStream() {
    return firestore.collection('pending').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return DeferredPayment(
            description: doc['description'],
            value: doc['value'],
            date: doc['date'].toDate(),
            id: doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> addPaymentToFirestore(DeferredPayment payment) async {
    try {
      await firestore.collection('pending').doc(payment.id).set(
        payment.toMap(),
      );
    } catch (error) {
      print('Erro ao adicionar pagamento ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removePaymentFromFirestore(String paymentId) async {
    try {
      await firestore.collection('pending').doc(paymentId).delete();
    } catch (error) {
      print('Erro ao remover pagamento do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<DeferredPayment>> getDeferredPaymentsFromFirestore() async {
    List<DeferredPayment> deferredPayments = [];
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('pending').get();
      deferredPayments = querySnapshot.docs
          .map((doc) =>
          DeferredPayment.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print('Erro ao obter pagamentos do Firestore: $error');
    }
    notifyListeners();
    return deferredPayments;
  }

  Stream<double> getTotalDeferredPaymentsByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = firestore
        .collection('pending')
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

  Stream<List<DeferredPayment>> getDeferredPaymentsByMonth(DateTime selectedMonth) {
    return firestore
        .collection('pending')
        .where('date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return DeferredPayment(
          description: doc['description'],
          value: doc['value'],
          date: doc['date'].toDate(),
          id: doc.id,
        );
      }).toList();
    });
  }
}