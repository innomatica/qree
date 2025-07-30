import 'package:flutter/material.dart';
import 'package:qree/data/service/sqflite.dart';

import '../../model/qritem.dart' show QrItem;

class QrItemViewModel extends ChangeNotifier {
  final SqliteService db;
  QrItemViewModel({required this.db});

  Future upsert(QrItem item) async {
    await db.upsertItem(item);
  }

  Future<bool> delete(int? id) async {
    if (id != null) {
      return await db.deleteItem(id);
    }
    return false;
  }
}
