import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:mi_primer_proyecto/models/user_model.dart';

class UserDatabase {
  static const NAMEDB = 'USERDB';
  static const VERSIONDB = 1;

  static Database? _database;
  Future<Database?> get database async { // PATRON SINGLETON
    if( _database != null ) return _database;
    return _database = await initDatabase();
  }
  
  Future<Database?> initDatabase() async {
    Directory folder =  await getApplicationDocumentsDirectory();
    String path = join(folder.path,NAMEDB);
    return openDatabase(
      path,
      version: VERSIONDB,
      onCreate: (db, version) {
        String query = '''CREATE TABLE tblUsers(
          idUser INTEGER PRIMARY KEY,
          userName varchar(50),
          passName varchar(32)
        )
        ''';
        db.execute(query);
      },
    );
  } 

  Future<int> INSERT(Map<String,dynamic> data) async {
    final con = await database;
    return con!.insert('tblUsers', data);
  }

  Future<int> UPDATE(Map<String,dynamic> data) async {
    final con = await database;
    return con!.update('tblUsers', 
      data, where: 'idUser=?', 
      whereArgs: [data['idUser']]
    );
  }
  Future<int> DELETE(int idUser) async {
    final con = await database;
    return con!.delete('tblUsers',where: 'idUser = ?', whereArgs: [idUser]);
  }
  Future<List<UserModel>> SELECT() async {
    final con = await database;
    final res = await con!.query('tblUsers');
    return res.map((user) => UserModel.fromMap(user)).toList();
  }
}