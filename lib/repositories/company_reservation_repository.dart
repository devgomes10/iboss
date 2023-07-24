import 'package:flutter/material.dart';
import 'package:iboss/data/db.dart';
import 'package:sqflite/sqflite.dart';

class CompanyReservationRepository extends ChangeNotifier {
  late Database db;
  double _saldo = 0;

  get saldo => _saldo;

  CompanyReservationRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getSaldo();
  }

  _getSaldo() async {
    db = await DB.instance.database;
    List companyReservation = await db.query('companyReservation', limit: 1);
    _saldo = companyReservation.first[saldo];
    notifyListeners();
  }

  setSaldo(double valor) async {
    db = await DB.instance.database;
    db.update('companyReservation', {
      'saldo': valor,
    });
    _saldo = valor;
    notifyListeners();
  }

}