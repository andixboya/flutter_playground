import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> getOrCreateDb() async {
    // 302-303) with this you establish connection to the db of your device ( instead of writing a connection string i guess).
    final dbPath = await sql.getDatabasesPath();
    // places.db is set as default db.
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(  
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    }, version: 1);
  }

  // insert == add.
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.getOrCreateDb();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 302-303) fething data without params == fetchAll, all you need is the name of the table name.
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.getOrCreateDb();
    return db.query(table);
  }
}
