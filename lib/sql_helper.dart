import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class SQLhelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'mrvtech',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future createItem(String title, String? description) async {
    final db = await SQLhelper.db();
    final data = {'title': title, 'description': description} ;
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLhelper.db();
    return db.query('items', orderBy: "id");
  }


  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLhelper.db();
    return db.query('items', where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future updateItem(int id, String title, String? description) async {
    final db = await SQLhelper.db();

    final data = {

      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id =?", whereArgs: [id]);
  }

  static Future<void> deleteItems(int id) async {
    final db = await SQLhelper.db();
    try {
      await db.delete("items", where: "id =?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item:$err");
    }
  }
}