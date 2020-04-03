import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'todo.dart';

class DBHelper {
    static Database _db;
    static const String ID = 'id';
    static const String TITLE = 'title';
    static const String DESCRIPTION = 'description';
    static const String ISDONE = 'isdone';
    static const String BGCOLOR = 'bgcolor';
    static const String TABLE = 'Todo';
    static const String DB_NAME = 'todo.db';

    Future<Database> get db async {
      if(_db != null){
        return _db;
      }
      _db = await initDb();
      return _db;
    }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $TITLE TEXT, $DESCRIPTION TEXT, $ISDONE BIT , $BGCOLOR TEXT)");
  }

  //Save Employee
  Future<Todo> save(Todo todo) async {
    var dbClient = await db;
    todo.id = await dbClient.insert(TABLE, todo.toMap());
    return todo;

    // await dbClient.transaction((txn) async {
    //   var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
    //   return await txn.rawInsert(query);
    // });
  }
  //select employee
  Future<List<Todo>> getTodo() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, TITLE, DESCRIPTION,ISDONE, BGCOLOR]);
    // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Todo> todos = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        todos.add(Todo.fromMap(maps[i]));
      }
    }
    return todos;
  }
  //get todo id
   Future<List<Todo>> getTodoID(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE,where: '$ID = ?', whereArgs: [id], columns: [ID, TITLE, DESCRIPTION,ISDONE,BGCOLOR]);
    // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Todo> todos = [];
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        todos.add(Todo.fromMap(maps[i]));
      }
    }
    return todos;
  }
  // update checkbox
  Future<int> toggleTodoItem (Todo todo) async {
    var dbClinet = await db;
    return await dbClinet.update(TABLE, todo.toMap(),
      where: '$ID = ?' , whereArgs: [todo.id]);
   
  }

  //delete employee
  Future<int> delete (int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }
  

  //update employee
  Future<int> update(Todo todo) async{
    var dbClinet = await db;
    return await dbClinet.update(TABLE, todo.toMap(),
      where: '$ID = ?' , whereArgs: [todo.id]);
  }

  //close the database
  Future close() async{
    var dbClient = await db;
    dbClient.close();
  }
}