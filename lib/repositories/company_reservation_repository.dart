import 'package:flutter/material.dart';
import 'package:iboss/models/company_reservation.dart';

class CompanyReservationRepository extends ChangeNotifier {
  List<CompanyReservation> companyReservations = [];

  CompanyReservationRepository ({
    required this.companyReservations
  });

  void add(CompanyReservation company) {
    companyReservations.add(company);
    notifyListeners();
  }

  void remove(int i) {
    companyReservations.removeAt(i);
    notifyListeners();
  }
}