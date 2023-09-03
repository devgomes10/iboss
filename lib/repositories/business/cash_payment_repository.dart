import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/business/cash_payment.dart';

class CashPaymentRepository extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<CashPayment>> getCashPaymentsStream() {
    return firestore.collection('cash_payments').snapshots().map(
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
      await firestore.collection('cash_payments').doc(payment.id).set(
        payment.toMap(), // Usando toMap() do modelo
      );
    } catch (error) {
      print('Erro ao adicionar pagamento ao Firestore: $error');
    }
    notifyListeners();
  }

  Future<void> removePaymentFromFirestore(String paymentId) async {
    try {
      await firestore.collection('cash_payments').doc(paymentId).delete();
    } catch (error) {
      print('Erro ao remover pagamento do Firestore: $error');
    }
    notifyListeners();
  }

  Future<List<CashPayment>> getCashPaymentsFromFirestore() async {
    List<CashPayment> cashPayments = [];
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('cash_payments').get();
      cashPayments = querySnapshot.docs
          .map((doc) =>
          CashPayment.fromMap(
              doc.data() as Map<String, dynamic>)) // Usando fromMap() do modelo
          .toList();
    } catch (error) {
      print('Erro ao obter pagamentos do Firestore: $error');
    }
    notifyListeners();
    return cashPayments;
  }

  double getTotalCashPaymentsByMonth(DateTime selectedMonth) {
    // Consultar o Firestore para obter pagamentos em dinheiro para o mês selecionado
    double total = 0.0;

    // Substitua "suaColecao" pelo nome da sua coleção Firestore
    firestore
        .collection('cash_payments')
        .where(
        'date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        total += doc['value'];
      });

      // Após calcular o total, você pode atualizar o estado ou notificar ouvintes, se necessário.
      // Isso depende de como você está gerenciando o estado no seu aplicativo.
      notifyListeners();
    });

    // Retornar 0.0 por padrão antes de concluir a consulta.
    return total;
  }

  Stream<double> getTotalCashPaymentsByMonthStream(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = firestore
        .collection('cash_payments')
        .where(
        'date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots();

    return queryStream.map((querySnapshot) {
      double total = 0.0;
      querySnapshot.docs.forEach((doc) {
        total += doc['value'];
      });
      return total;
    });
  }

  Stream<List<CashPayment>> getCashPaymentsByMonth(DateTime selectedMonth) {
    // Consultar o Firestore para obter pagamentos em dinheiro para o mês selecionado
    return firestore
        .collection('cash_payments')
        .where('date',
        isGreaterThanOrEqualTo: DateTime(selectedMonth.year, selectedMonth.month, 1),
        isLessThan: DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
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