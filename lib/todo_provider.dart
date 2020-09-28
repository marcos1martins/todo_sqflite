import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'todo.dart';

class TodoProvider {
  Database _db;

  Future<Database> _getDb() async {
    if (_db == null) {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'demo.db');
      _db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
        create table $tableTodo ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDone integer not null)
      ''');
      });
    }
    return _db;
  }

  organizeByDone(List<Todo> disorganizedList) {
    return disorganizedList.sort((a, b) {
      if (a.done == b.done) {
        return 0;
      }
      if (a.done == false && b.done == true) {
        return 1;
      }
      return -1;
    });
  }

  Future<List<Todo>> getAll() async {
    final Database db = await _getDb();
    List<Map<String, dynamic>> listMap = await db.query(tableTodo);
    List<Todo> list = _toList(listMap);
    return organizeByDone(list);
  }

  List<Todo> _toList(List<Map<String, dynamic>> result) {
    final List<Todo> list = List();
    for (Map<String, dynamic> row in result) {
      final Todo todo = Todo.fromMap(row);
      list.add(todo);
    }
    return list;
  }

  Future<Todo> insert(Todo todo) async {
    final Database db = await _getDb();
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    final Database db = await _getDb();
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    final Database db = await _getDb();
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    final Database db = await _getDb();
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => _db.close();
}
