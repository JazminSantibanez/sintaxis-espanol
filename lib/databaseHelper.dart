import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  static final _dbName = 'game.db';
  static final _dbVersion = 1;
  static final _tableName = 'Sentence';

  static final columnId = '#';
  static final columnName = 'name';



  DatabaseHelper._privateConstructo();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructo();

  static Database _database;
  Future<Database> get database async{
    if(_database!=null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }


  _initiateDatabase () async {
    Directory directory = await getApplicationDocumentsDirectory();
    var dbDir = await getDatabasesPath();
    var path = join(dbDir, _dbName);
    //String path = join(directory.path, _dbName);
    await openDatabase(path);
    

  }

  Future _onCreate(Database db, int version){
    db.execute(
      ''' 
      CREATE TABLE $_tableName {
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXTNOTNULL}

      '''
    );
  }

  Future<int> insert(Map <String, dynamic> row) async {

    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String,dynamic>>> queryAll() async{
    Database db = await instance.database;
    return await db.query(_tableName);

  }

  Future update (Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row [columnId];
    return await db.update(_tableName, row, where:'$columnId = ?', whereArgs:[id]);
 
  }

  Future delete(int id) async{
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);

  }
}
