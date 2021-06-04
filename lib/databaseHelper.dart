import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = 'game.db';
  static final _tableName = 'Sentence';

  static final columnId = '"#"';
  static final columnName = 'name';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _copyDatabase() async {
    // Construct a file path to copy database to
    String databasesDirectory = await getDatabasesPath();
    String path = join(databasesDirectory, _dbName);

    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', _dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }
  }

  _initiateDatabase() async {
    await _copyDatabase();

    // Directory directory = await getApplicationDocumentsDirectory();
    var dbDir = await getDatabasesPath();
    var path = join(dbDir, _dbName);
    // String path = join(directory.path, _dbName);
    return await openDatabase(path);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }


  Future update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }
  Future<int> numRows() async{
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Sentence'));
  }

  Future<List<Map<String, dynamic>>> getSentencetById(int id) async {
    Database db = await instance.database; 
    //var result = await db.query("Sentence", where: "id = ", whereArgs: [id]); 
    return await db.rawQuery('SELECT * FROM Sentence WHERE "#" = $id ');
    //return result.isNotEmpty ? Sentence.fromMap(result.first) : Null; 
  } 
}
