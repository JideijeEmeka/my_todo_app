import 'package:flutter/material.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database;
  static int version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if(_database != null) {
      return;
    }
    try{
      String _path = await getDatabasesPath() + 'tasks.db';
      _database = await openDatabase(
        _path,
        version: version,
        onCreate: (_database, version) {
          debugPrint('Creating a new one...');
          return _database.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, repeat STRING, "
                "color INTEGER, "
                "isCompleted INTEGER)"
          );
        }
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<int> insert(Task? task) async {
    debugPrint('insert function called');
    return await _database?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>?> query() async {
    debugPrint('query function called');
    return await _database?.query(_tableName);
  }

  static delete(Task task) async {
    return await _database?.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }
  
}