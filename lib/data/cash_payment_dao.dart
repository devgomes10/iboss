import 'package:flutter/cupertino.dart';
import 'package:iboss/models/cash_payment.dart';
import 'package:sqflite/sqflite.dart';
import 'db.dart';

class CashPaymentDao extends ChangeNotifier {
  late Database db;

  static String cashPayment = 'CREATE TABLE $_cashPaymentName ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_description TEXT, '
      '$_value REAL, '
      '$_date NUMERIC)';

  static const String _cashPaymentName = 'cashPayments';
  static const _description = 'description';
  static const String _value = 'value';
  static const String _date = 'date';

  save(CashPayment inCash) async {
    print('iniciando o save: ');
    db = await DB.instance.database;
    Map<String, dynamic> paymentMap = toMap(inCash);
    return await db.insert(_cashPaymentName, paymentMap);
  }

  Map<String, dynamic> toMap(CashPayment inCash) {
    print('convertenbdo em map: ');
    final Map<String, dynamic> cashPaymentList = Map();
    cashPaymentList[_description] = inCash.description;
    cashPaymentList[_value] = inCash.value;
    cashPaymentList[_date] = inCash.date;
    print('mapa de tarefas: $cashPaymentList');
    return cashPaymentList;
  }

  Future<List<CashPayment>> findAll() async {
    print('acessando findAll: ');
    db = await DB.instance.database;
    final List<Map<String, dynamic>> result =
        await db.query(_cashPaymentName);
    print('Procurando dados no banco de dados... encontrado: $result');
    return toList(result);
  }

  List<CashPayment> toList(List<Map<String, dynamic>> cashPaymentList) {
    print('Convertendo para lista: ');
    final List<CashPayment> nowPayments = [];
    for (Map<String, dynamic> line in cashPaymentList) {
      final CashPayment payment = CashPayment(
          description: line[_description],
          value: line[_value],
          date: line[_date]);
      nowPayments.add(payment);
    }
    print('Lista de tarefas $nowPayments');
    return nowPayments;
  }

  Future<List<CashPayment>> find(String entryDescription) async {
    print('acessando find: ');
    db = await DB.instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      _cashPaymentName,
      where: '$_description = ?',
      whereArgs: [entryDescription],
    );
    print('tarefa encontrada: ${toList(result)}');
    return toList(result);
  }

  delete(String entryDescription) async {
    print('deletando tarefa: $entryDescription');
    db = await DB.instance.database;
    return db.delete(
      _cashPaymentName,
      where: '$_description',
      whereArgs: [entryDescription],
    );
  }
}
