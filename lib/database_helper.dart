import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "wiki_database.db";

  static final _databaseVersion = 1;

  static final table = 'search_history';

  static final columnId = '_id';
  static final columnText = 'text';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
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
            $columnId INTEGER PRIMARY KEY,
            $columnText TEXT NOT NULL
          )
          ''');
  }

  // Helper methods
  Future<void> insertSearchText(String text) async {
    Map<String, dynamic> row = {
      'text': text,
    };
    final Database db = await database;
    int id = await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Row ID $id");
  }

  Future<List<SearchHistory>> getAllSearchHistories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    print("get map $maps");
    return List.generate(maps.length, (i) {
      return SearchHistory(
        text: maps[i]['text'],
        id: maps[i]["_id"],
      );
    });
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}

class SearchHistory {
  final String text;
  final int id;

  SearchHistory({this.text, this.id});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'id': id,
    };
  }
}
