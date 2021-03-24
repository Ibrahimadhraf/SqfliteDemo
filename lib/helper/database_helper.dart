import 'package:flutter_app/helper/constants.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper db=DatabaseHelper._();
  static Database _dataBase;

  Future<Database> get dataBase async {
    if (_dataBase != null) return _dataBase;
    _dataBase = await initDb();
    return _dataBase;
  }
  initDb() async {
    String path = join(await getDatabasesPath(), 'UserDatabase.db');
   return  await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
   CREATE TABLE $tableUser (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnName TEXT NOT NULL ,
    $columnPhone  TEXT NOT NULL ,
    $columnEmail TEXT NOT NULL)
   ''');
        });

  }
  /// CURD
   Future<void>insertUser(UserModel user)async{
    var dbClient=  await dataBase;
    await dbClient.insert(tableUser, user.toJson() ,conflictAlgorithm: ConflictAlgorithm.replace);

  }
  Future<void>updateUser(UserModel user)async{
    var dbClient=  await  dataBase;
    await dbClient.update(tableUser, user.toJson() ,where: '$columnId=?' ,whereArgs: [user.id]);

  }
  Future<UserModel>getUser(int id)async{
    var dbClient=  await  dataBase;
   List<Map> maps= await dbClient.query(tableUser,  where: '$columnId=?' ,whereArgs: [id]);
    return    maps.length==0?  null : UserModel.fromJson(maps.first);
  }
  Future<List<UserModel>>getAllUser()async{
    var dbClient=  await  dataBase;
    List<Map> maps= await dbClient.query(tableUser);
   List<UserModel> list= maps.isNotEmpty ?
       maps.map((e) => UserModel.fromJson(e)).toList():[];
     return    list;
  }
  Future<void>deleteUser(int id)async{
    var dbClient=  await  dataBase;
    await dbClient.delete(tableUser ,where: '$columnId=?' ,whereArgs: [id]);

  }
}

