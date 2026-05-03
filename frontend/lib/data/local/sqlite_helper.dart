import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'shcc_sales_v2.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid              TEXT UNIQUE NOT NULL,
        sales_person_name TEXT,
        base_rate         REAL,
        gst               REAL,
        tcs               REAL,
        quantity          REAL,
        type_of_sale      TEXT,
        quality           TEXT,
        port_name         TEXT,
        buyer_name        TEXT,
        payment_terms     TEXT,
        sync_status       TEXT DEFAULT 'pending',
        created_at        TEXT,
        updated_at        TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        remote_id  TEXT,
        name       TEXT,
        grade      TEXT,
        gcv        TEXT,
        price      REAL,
        unit       TEXT,
        available  INTEGER DEFAULT 1,
        synced_at  TEXT
      )
    ''');
  }

  static Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    return db.insert('orders', order, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getPendingOrders() async {
    final db = await database;
    return db.query('orders', where: 'sync_status = ?', whereArgs: ['pending']);
  }

  static Future<void> markSynced(String uuid) async {
    final db = await database;
    await db.update('orders', {'sync_status': 'synced', 'updated_at': DateTime.now().toIso8601String()},
      where: 'uuid = ?', whereArgs: [uuid]);
  }

  static Future<void> markFailed(String uuid) async {
    final db = await database;
    await db.update('orders', {'sync_status': 'failed', 'updated_at': DateTime.now().toIso8601String()},
      where: 'uuid = ?', whereArgs: [uuid]);
  }

  static Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await database;
    return db.query('orders', orderBy: 'created_at DESC');
  }
}
