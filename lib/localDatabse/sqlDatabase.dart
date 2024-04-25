import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'post.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE posts ( id INTEGER PRIMARY KEY, data TEXT)",
        );
      },
    );
  }

  Future<int> insertTodo(Map<String, dynamic> reel) async {
    final db = await database;
    return await db!.insert('posts', reel);
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await database;
    return await db!.query('posts');
  }

  Future<int> updateTodo(Map<String, dynamic> reel) async {
    final db = await database;
    return await db!.update('posts', reel, where: 'id = ?', whereArgs: [reel['id']]);
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db!.delete('posts', where: 'id = ?', whereArgs: [id]);
  }



}
