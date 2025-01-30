import 'package:flutter_local_storage/models/Users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();
  static Database? _db;
  final databaseName='User_database.db';
  final tableName='Users';

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
          $_id INTEGER PRIMARY KEY AUTOINCREMENT,
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

  Future<int> insert(Users user) async {
    Database db=await instance.databaseCondition;
    return db.insert(tableName, user.toJson());
  }

  Future<List<Users>> display() async {
    Database db=await instance.databaseCondition;
    List<Map<String,dynamic>> map=await db.query(tableName);
    return List.generate(map.length, (i){
      return Users.fromJson(map[i]);
    });
  }
  
  Future<int> updatebyId(Users user) async{
    Database db=await instance.databaseCondition;
    return await db.update(
      tableName, user.toJson(), where: 'id=?', whereArgs: [user.id]
      );
  }

  Future<int> delete(int id) async{
    Database db=await instance.databaseCondition;
    return await db.delete(tableName, where: 'id=?', whereArgs: [id]);
  }
}
