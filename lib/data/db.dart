import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Future<Database> getDatabase() async {
//   final String path = join(await getDatabasesPath(), 'manager.db');
//   return openDatabase(path, onCreate: (db, version) {
//     db.execute(CashPaymentDao.cashPayment);
//   }, version: 1);
// }

class DB {
  DB._();
  static final DB instance = DB._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), 'manager.db'),
    version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    // await db.execute(_cashPayment);
    // await db.execute(_deferredPayment);
    // await db.execute(_companyFixedExpenses);
    // await db.execute(_companyVariableExpenses);
    // await db.execute(_fixedEntries);
    // await db.execute(_variableEntries);
    await db.execute(_companyReservation);
    await db.insert('companyReservation', {'saldo': 0});
  }

  String get _companyReservation => '''
    CREATE TABLE companyReservation (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      saldo REAL 
    );
  ''';


}