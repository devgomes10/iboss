import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/business/cash_payment.dart';

class CashPaymentRepository extends ChangeNotifier {
  late String uidReceived;
  late CollectionReference cashPaymentCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CashPaymentRepository() {
    uidReceived = FirebaseAuth.instance.currentUser!.uid;
    cashPaymentCollection =
        FirebaseFirestore.instance.collection('cashPayments_$uidReceived');
  }

  Stream<List<CashPayment>> getCashPaymentsStream() {
    return cashPaymentCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return CashPayment(
            description: doc['description'],
            value: doc['value'],
            date: doc['date'].toDate(),
            id: doc.id,
          );
        }).toList();
      },
    );
  }

  Future<void> addPaymentToFirestore(CashPayment payment) async {
    try {
      await cashPaymentCollection.doc(payment.id).set(
            payment.toMap(),
          );
    } catch (error) {
      const Text(
        "erro ao adicionar pagamento",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
  }

  Future<void> removePaymentFromFirestore(String paymentId) async {
    try {
      await cashPaymentCollection.doc(paymentId).delete();
    } catch (error) {
      const Text(
        "erro ao remover pagamento",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
  }

  Future<List<CashPayment>> getCashPaymentsFromFirestore() async {
    List<CashPayment> cashPayments = [];
    try {
      QuerySnapshot querySnapshot = await cashPaymentCollection.get();
      cashPayments = querySnapshot.docs
          .map((doc) => CashPayment.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      const Text(
        "erro ao carregar dados pagamento",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
    return cashPayments;
  }

  Stream<double> getTotalCashPaymentsByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = cashPaymentCollection
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

  Stream<List<CashPayment>> getCashPaymentsByMonth(DateTime selectedMonth) {
    return cashPaymentCollection
        .where('date',
            isGreaterThanOrEqualTo:
                DateTime(selectedMonth.year, selectedMonth.month, 1),
            isLessThan:
                DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return CashPayment(
          description: doc['description'],
          value: doc['value'],
          date: doc['date'].toDate(),
          id: doc.id,
        );
      }).toList();
    });
  }
}
