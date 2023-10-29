import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/business/revenue_model.dart';

class RevenueController extends ChangeNotifier {
  late String uidRevenue;
  late CollectionReference revenueCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RevenueController() {
    uidRevenue = FirebaseAuth.instance.currentUser!.uid;
    revenueCollection =
        FirebaseFirestore.instance.collection('revenue_$uidRevenue');
  }

  Stream<List<RevenueModel>> getRevenueStream() {
    return revenueCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return RevenueModel(
              description: doc['description'],
              value: doc['value'],
              isReceived: doc["isReceived"],
              receiptDate: doc["receiptDate"].toDate(),
              // catalog: doc["catalog"],
              isRepeat: doc["isRepeat"],
              dateNow: doc['dateNow'].toDate(),
              id: doc.id,
            );
          },
        ).toList();
      },
    );
  }

  Future<void> addRevenueToFirestore(RevenueModel revenue) async {
    try {
      await revenueCollection.doc(revenue.id).set(
            revenue.toMap(),
          );
    } catch (error) {
      const Text(
        "erro ao adicionar pagamento",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
  }

  Future<void> removeRevenueFromFirestore(String revenueId) async {
    try {
      await revenueCollection.doc(revenueId).delete();
    } catch (error) {
      const Text(
        "erro ao remover pagamento",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
  }

  Future<List<RevenueModel>> getRevenueFromFirestore() async {
    List<RevenueModel> revenues = [];
    try {
      QuerySnapshot querySnapshot = await revenueCollection.get();
      revenues = querySnapshot.docs
          .map(
              (doc) => RevenueModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      const Text(
        "erro ao carregar dados pagamento",
        style: TextStyle(fontSize: 12),
      );
    }
    notifyListeners();
    return revenues;
  }

  Stream<double> getTotalRevenueByMonth(DateTime selectedMonth) {
    Stream<QuerySnapshot> queryStream = revenueCollection
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

  Stream<List<RevenueModel>> getRevenueByMonth(DateTime selectedMonth) {
    return revenueCollection
        .where('date',
            isGreaterThanOrEqualTo:
                DateTime(selectedMonth.year, selectedMonth.month, 1),
            isLessThan:
                DateTime(selectedMonth.year, selectedMonth.month + 1, 1))
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return RevenueModel(
          description: doc['description'],
          value: doc['value'],
          isReceived: doc["isReceived"],
          receiptDate: doc["receiptDate"].toDate(),
          // catalog: doc["catalog"],
          isRepeat: doc["isRepeat"],
          dateNow: doc['dateNow'].toDate(),
          id: doc.id,
        );
      }).toList();
    });
  }

  Future<void> updateReceivedStatus(String revenueId, bool isReceived) async {
    try {
      await revenueCollection.doc(revenueId).update({"isReceived": isReceived});
    } catch (error) {
      const Text("Erro ao atualizar o status");
    }
  }

  Future<void> updateRepeatStatus(String revenueId, bool isRepeat) async {
    try {
      await revenueCollection.doc(revenueId).update({"isRepeat": isRepeat});
    } catch (error) {
      const Text("Erro ao atualizar o status");
    }
  }
}
