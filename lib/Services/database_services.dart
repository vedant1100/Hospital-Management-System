import 'package:flutter_local_storage/models/libraryModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();
  static Database? _db;
  final databaseName='Library_database.db';
  final tableName='Library';

  final String _id='id';
  final String firstName='firstName';
  final String lastName='lastName';
  final String mobileNo='mobileNo';

  Future<Database> get databaseCondition async{
    if(_db!=null){
      return _db!;
    }
    _db= await initialize();
    return _db!;
  }

  Future<String> get fullPath async{
    final path= await getDatabasesPath();
    return join(path,databaseName);
  }

  Future<Database> initialize() async{
    final path=await fullPath;
    var database=await openDatabase(
      path,
      onCreate: (db, version){
        db.execute(''' 
        CREATE TABLE $tableName(
          $_id INTEGER PRIMARY KEY,
          $firstName TEXT NOT NULL,
          $lastName TEXT NOT NULL,
          $mobileNo INTEGER
        )
        ''');
      },
      version: 1,
    );
    return database;
  }

  // Future<int> insert(String tableName, Map<String,dynamic> json) async {
  //   Future<List<Map<String,dynamic>>> query(String tableName, {String? where, List<dynamic>? whereArgs}) async{
  //     return _db!.query(
  //       tableName,
  //       where: where,
  //       whereArgs: whereArgs
  //     );
  //   }
  //   return _db!.insert(tableName, json);
  // } 

  Future<int> insert(String tableName, Map<String, dynamic> json) async {
    return _db!.insert(tableName, json);
  }

  Future<List<Map<String, dynamic>>> query(String tableName, {String? where, List<dynamic>? whereArgs,}) async {
    return _db!.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }
  
  Future<int> update(String tableName, Map<String,dynamic> json, {String? where, List<dynamic>? whereArgs}) async{
    return _db!.update(
      tableName,
      json,
      where: where,
      whereArgs: whereArgs
      );
  }

  Future<int> delete(String tableName,{String? where, List<dynamic>? whereArgs}) async{
    return _db!.delete(
      tableName,
      where: where,
      whereArgs: whereArgs
    );
  }
}
