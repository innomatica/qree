import 'package:logging/logging.dart';
import 'package:qree/model/qritem.dart' show QrItem;
import 'package:sqflite/sqflite.dart';

import 'schema.dart';

class SqliteService {
  Database? _db;
  // ignore: unused_field
  final _logger = Logger('SqliteService');

  Future open() async {
    _db = await openDatabase(
      dbName,
      version: dbVersion,
      onCreate: (db, version) async {
        for (final sql in schemaV1Create) {
          await db.execute(sql);
        }
        for (final sql in demoItems) {
          final data = sql.toDbMap();
          await db.rawInsert(
            "INSERT INTO qr_items (${data.keys.join(',')})"
            "VALUES (${List.filled(data.length, '?').join(',')})",
            [...data.values],
          );
        }
      },
    );
    return _db;
  }

  Future close() async {
    await _db?.close();
  }

  Future<Database> getDatabase() async {
    return _db ?? await open();
  }

  Future<List<QrItem>> getItems() async {
    final db = await getDatabase();
    final rows = await db.rawQuery("SELECT * FROM qr_items");
    return rows.map((e) => QrItem.fromDbMap(e)).toList();
  }

  Future<bool> upsertItem(QrItem item) async {
    final db = await getDatabase();
    final data = item.toDbMap();
    int ret = 0;
    if (item.id == null) {
      ret = await db.rawInsert(
        "INSERT INTO qr_items (${data.keys.join(',')})"
        " VALUES(${List.filled(data.length, "?").join(',')})",
        [...data.values],
      );
    } else {
      ret = await db.rawUpdate(
        "UPDATE qr_items SET ${data.keys.map((e) => '$e = ?').join(',')}"
        " WHERE id=?",
        [...data.values, item.id],
      );
    }
    return ret > 0;
  }

  Future<bool> deleteItem(int id) async {
    final db = await getDatabase();
    final res = await db.rawDelete("DELETE from qr_items WHERE id = ?", [id]);
    return res == 1;
  }
}
