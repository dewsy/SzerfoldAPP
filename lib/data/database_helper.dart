import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "DailyDB2.db";
  static final _databaseVersion = 1;

  static final table = 'dailies';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDate = 'date';
  static final columnHtml = 'html';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT,
            $columnDate INTEGER NOT NULL UNIQUE,
            $columnHtml TEXT
          )
          ''');
  }

  Future<int> insertOrUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    try {
      return await db.insert(table, row);
    } catch (e) {
      int date = row[columnDate];
      return await db
          .update(table, row, where: '$columnDate = ?', whereArgs: [date]);
    }
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table, orderBy: '$columnDate DESC');
  }

  Future<List<Map<String, dynamic>>> query10Rows(DateTime date) async {
    Database db = await instance.database;
    var result = await db.query(table,
        where: '$columnDate <= ?',
        whereArgs: [date.millisecondsSinceEpoch],
        limit: 11,
        orderBy: "$columnDate DESC");
    return result;
  }

  Future<List<Map<String, dynamic>>> queryLatest() async {
    Database db = await instance.database;
    return db
        .rawQuery("SELECT * FROM $table ORDER BY $columnDate DESC LIMIT 1;");
  }

  Future<List<Map<String, dynamic>>> queryByDate(DateTime date) async {
    Database db = await instance.database;
    return await db.query(table,
        where: '$columnDate = ?', whereArgs: [date.millisecondsSinceEpoch]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String date = row[columnDate];
    return await db
        .update(table, row, where: '$columnDate = ?', whereArgs: [date]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    Database db = await instance.database;
    db.execute("DELETE FROM $table;");
  }

  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    File(path).deleteSync();
  }
}

final dbHelper = DatabaseHelper.instance;
