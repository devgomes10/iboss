import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/business/deferred_payment.dart';

class DeferredPaymentRepository extends ChangeNotifier {
  late String uidPending;
  late CollectionReference deferredPaymentCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DeferredPaymentRepository() {
    uidPending = FirebaseAuth.instance.currentUser!.uid;
    deferredPaymentCollection =
        FirebaseFirestore.instance.collection('deferredPayments_$uidPending');
  }

  Stream<List<DeferredPayment>> getDeferredPaymentsStream() {
    return deferredPaymentCollection.snapshots().map(
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
      await deferredPaymentCollection.doc(payment.id).set(
            payment.toMap(),
          );
    } catch (error) {
      const Text("Erro ao adicionar pagamento", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
  }

  Future<void> removePaymentFromFirestore(String paymentId) async {
    try {
      await deferredPaymentCollection.doc(paymentId).delete();
    } catch (error) {
      const Text("Erro ao remover pagamento", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
  }

  Future<List<DeferredPayment>> getDeferredPaymentsFromFirestore() async {
    List<DeferredPayment> deferredPayments = [];
    try {
      QuerySnapshot querySnapshot = await deferredPaymentCollection.get();
      deferredPayments = querySnapshot.docs
          .map((doc) =>
              DeferredPayment.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      const Text("Erro ao carregar dados", style: TextStyle(fontSize: 12),);
    }
    notifyListeners();
    return deferredPayments;
  }

  Stream<double> getTotalDeferredPaymentsByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = deferredPaymentCollection
        .where('date',
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

  Stream<List<DeferredPayment>> getDeferredPaymentsByMonth(
      DateTime selectedMonth) {
    return deferredPaymentCollection
        .where(
          'date',
          isGreaterThanOrEqualTo:
              DateTime(selectedMonth.year, selectedMonth.month, 1),
          isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1),
        )
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
