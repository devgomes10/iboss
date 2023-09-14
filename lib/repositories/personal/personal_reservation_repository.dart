import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PersonalReservationRepository extends ChangeNotifier {
  late String uidPersonalReservation;
  late CollectionReference personalReservationCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  PersonalReservationRepository() {
    uidPersonalReservation = FirebaseAuth.instance.currentUser!.uid;
    personalReservationCollection = FirebaseFirestore.instance
        .collection('personal_reservation_$uidPersonalReservation');
  }

  Future<void> updatePersonalReservation(double newPersonalReservation) async {
    await personalReservationCollection
        .doc('currentPersonalReservation')
        .set({'value': newPersonalReservation});

    notifyListeners();
  }

  Future<double?> getCurrentPersonalReservation() async {
    final doc = await personalReservationCollection
        .doc('currentPersonalReservation')
        .get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final personalReservationValue = data['value'] as double?;
      return personalReservationValue;
    }
    return null;
  }
}
