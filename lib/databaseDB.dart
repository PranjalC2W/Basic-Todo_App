import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'TodoApp.dart';

dynamic database;

Future<void> databaseFun() async {
  database = openDatabase(
    path.join(await getDatabasesPath(), "ToDoDB.db"),
    version: 1,
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE todoInfo(taskId INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT, date TEXT)');
    },
  );
  getData();
}

//insert data
Future importData(Todo obj) async {
  final localDB = await database;
  await localDB.insert(
    "todoInfo",
    obj.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

//getdata
Future<List<Todo>> getData() async {
  final localDB = await database;
  List<Map<String, dynamic>> listData = await localDB.query("todoInfo");
  return List.generate(listData.length, (i) {
    return Todo(
      taskId: listData[i]['taskId'],
      title: listData[i]['title'],
      desc: listData[i]['desc'],
      date: listData[i]['date'],
    );
  });
}

//deleteTask
Future deleteTask(Todo todoObj) async {
  final localDB = await database;
  await localDB.delete(
    'todoInfo',
    where: 'taskId=?',
    whereArgs: [todoObj.taskId],
  );
}

//update task
Future updateTask(Todo todoobj) async {
  final localDB = await database;
  await localDB.update(
    "todoInfo",
    todoobj.toMap(),
    where: 'taskId=?',
    whereArgs: [todoobj.taskId],
  );
}
