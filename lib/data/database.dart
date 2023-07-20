import 'package:iboss/data/cash_payment_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'manager.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(CashPaymentDao.cashPayment);
  }, version: 1);
}
