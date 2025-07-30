import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:qree/data/service/sqflite.dart';

import '../../model/qritem.dart' show QrItem;

class HomeViewModel extends ChangeNotifier {
  final SqliteService db;
  HomeViewModel({required this.db});
  // ignore: unused_field
  final _logger = Logger('HomeViewModel');

  List<QrItem> _items = [];

  List<QrItem> get items => _items;

  Future load() async {
    _items = await db.getItems();
    _logger.fine('items:$_items');
    notifyListeners();
  }
}
