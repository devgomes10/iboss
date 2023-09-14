import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnterpriseReserveRepository extends ChangeNotifier {
  late String uidReserveEnterprise;
  late CollectionReference reserveEnterpriseCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  EnterpriseReserveRepository() {
    uidReserveEnterprise = FirebaseAuth.instance.currentUser!.uid;
    reserveEnterpriseCollection =
        FirebaseFirestore.instance.collection('enterprise_reserve_$uidReserveEnterprise');
  }

  Future<void> updateReserveEnterprise(double newReserveEnterprise) async {
    await reserveEnterpriseCollection.doc('currentReserveEnterprise').set({'value': newReserveEnterprise});

    notifyListeners();
  }

  Future<double?> getCurrentReserveEnterprise() async {
    final doc = await reserveEnterpriseCollection.doc('currentReserveEnterprise').get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final reserveEnterpriseValue = data['value'] as double?;
      return reserveEnterpriseValue;
    }
    return null;
  }

}
