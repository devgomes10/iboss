import 'package:flutter/material.dart';
import 'package:iboss/models/personal_reservation.dart';


class PersonalReservationRepository extends ChangeNotifier {
  List<PersonalReservation> personalReservations = [];

  PersonalReservationRepository ({
    required this.personalReservations
  });

  void add(PersonalReservation personal) {
    personalReservations.add(personal);
    notifyListeners();
  }

  void remove(int i) {
    personalReservations.removeAt(i);
    notifyListeners();
  }
}