import 'dart:io';
import 'package:dompetku/models/transaction.dart' as tx;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String tableTrans = 'trans';
  static const String columnId = '_id';
  static const String columnPayee = 'payee';
  static const String columnAmount = 'amount';
  static const String columnDate = 'date';
  static const String columnCategory = 'category';

  static final String _databaseName = "dompetku.db";

  static final int _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Map<String, dynamic> toMap(tx.Transaction trans) {
    var map = <String, dynamic>{
      columnPayee: trans.payee,
      columnAmount: trans.amount,
      columnDate: trans.date.millisecondsSinceEpoch,
      columnCategory: trans.category
    };
    if (null != trans.id) {
      map[columnId] = trans.id;
    }
    return map;
  }

  tx.Transaction fromMap(Map<String, dynamic> map) {
    return tx.Transaction(
      id: map[columnId],
      payee: map[columnPayee],
      amount: map[columnAmount],
      date: DateTime.fromMillisecondsSinceEpoch(map[columnDate]),
      category: map[columnCategory],
    );
  }

  static Database _database;

  Future<Database> get database async {
    if (null != _database) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableTrans (
                $columnId INTEGER PRIMARY KEY,
                $columnPayee TEXT NOT NULL,
                $columnAmount REAL NOT NULL,
                $columnDate INTEGER NOT NULL,
                $columnCategory TEXT
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(tx.Transaction trans) async {
    Database db = await database;
    int id = await db.insert(tableTrans, toMap(trans));
    return id;
  }

  Future<tx.Transaction> queryTransaction(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableTrans,
        columns: [
          columnId,
          columnPayee,
          columnAmount,
          columnDate,
          columnCategory
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return fromMap(maps.first);
    }
    return null;
  }

  Future<List<tx.Transaction>> queryAllTransactions() async {
    Database db = await database;
    List<Map> maps = await db.rawQuery('SELECT * FROM $tableTrans');
    return maps.map((m) => fromMap(m)).toList();
  }

  Future<int> deleteTransaction(int id) async {
    Database db = await database;
    int count =
        await db.delete(tableTrans, where: '$columnId = ?', whereArgs: [id]);
    return count;
  }

  Future<int> updateTransaction(
      {int id,
      String payee,
      double amount,
      String category,
      DateTime date}) async {
    Database db = await database;
    int count = await db.update(
      tableTrans,
      <String, dynamic>{
        columnPayee: payee,
        columnAmount: amount,
        columnDate: date.millisecondsSinceEpoch,
        columnCategory: category,
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return count;
  }
}
