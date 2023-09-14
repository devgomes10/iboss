import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OpportunityReserveRepository extends ChangeNotifier {
  late String uidOpportunityReserve;
  late CollectionReference reserveRepositoryCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  OpportunityReserveRepository() {
    uidOpportunityReserve = FirebaseAuth.instance.currentUser!.uid;
    reserveRepositoryCollection =
        FirebaseFirestore.instance.collection('opportunity_reserve_$uidOpportunityReserve');
  }

  Future<void> updateOpportunityReserve(double newOpportunityReserve) async {
    await reserveRepositoryCollection.doc('currentOpportunityReserve').set({'value': newOpportunityReserve});

    notifyListeners();
  }

  Future<double?> getCurrentOpportunityReserve() async {
    final doc = await reserveRepositoryCollection.doc('currentOpportunityReserve').get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final opportunityReserveValue = data['value'] as double?;
      return opportunityReserveValue;
    }
    return null;
  }

}
