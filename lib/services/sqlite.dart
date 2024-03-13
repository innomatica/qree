import 'package:flutter/foundation.dart';
import 'package:qreeapp/models/qritem.dart';
import 'package:sqflite/sqflite.dart';

const databaseName = 'qree_db.db';
const databaseVersion = 2;
const tableQrItems = 'qritems';
const sqlCreateQrItems = 'CREATE TABLE $tableQrItems ('
    'id INTEGER PRIMARY KEY,'
    'title TEXT,'
    'text TEXT,'
    'type INTEGER,'
    'position INTEGER,'
    'info TEXT)';
const sqlCreateTables = [sqlCreateQrItems];
const sqlDropQrItems = 'DROP TABLE IF EXISTS $tableQrItems';
const sqlDropTables = [sqlDropQrItems];

final homepageItem = QrItem(
  title: 'Visit Our App Store',
  type: QrType.url,
  position: 0,
  info: {
    'site': 'Homepage',
    'url': 'https://play.google.com/store/apps/dev?id=7151987952459587384',
    'data': 'https://play.google.com/store/apps/dev?id=7151987952459587384'
  },
);
final instagramItem = QrItem(
  title: 'Check MSF on Instagram',
  type: QrType.url,
  position: 1,
  info: {
    'site': 'Instagram',
    'url': 'https://www.instagram.com/doctorswithoutborders/',
    'data': 'https://www.instagram.com/doctorswithoutborders/',
  },
);
final twitterItem = QrItem(
  title: 'Civicus Twitter Account',
  type: QrType.url,
  position: 2,
  info: {
    'site': 'Twitter',
    'url': 'https://twitter.com/CIVICUSalliance',
    'data': 'https://twitter.com/CIVICUSalliance',
  },
);
final telItem = QrItem(
  title: 'Call My Number',
  text: '804-222-1111',
  type: QrType.tel,
  position: 3,
  info: {
    'phone': '+1-804-222-1111',
    'data': 'tel:+1-804-222-1111',
  },
);
final icalItem = QrItem(
  title: 'Event Schedule',
  type: QrType.iCalendar,
  position: 4,
  info: {
    "description": "Let's have some fun",
    "location": "Babylon",
    "startTime": "2022-06-25T20:00:00.000",
    "endTime": "2022-06-25T21:37:00.000",
    "data": "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:com.innomatic.sonoreapp\n"
        "BEGIN:VEVENT\nDTSTART:20220626T000000Z\nDTEND:20220626T013700Z\n"
        "SUMMARY:Weekend Meetup\nDESCRIPTION:Let's have some fun\n"
        "LOCATION:Babylon\nEND:VEVENT\nEND:VCALENDAR\n"
  },
);
final smsItem = QrItem(
  title: 'Text Me',
  type: QrType.sms,
  position: 5,
  info: {
    'phone': '+1-804-222-1111',
    'message': 'Hello there',
    'data': 'sms:+1-804-222-1111?body=Hi%20there',
  },
);
final mailtoItem = QrItem(
  title: 'Send Me an Email',
  text: 'jane.doe@example.com',
  type: QrType.mailto,
  position: 6,
  info: {
    'email': 'jane.doe@example.com',
    'subject': '',
    'body': '',
    'data': 'mailto:jane.doe@example.com',
  },
);
final vcardItem = QrItem(
  title: 'My Business Card',
  text: 'Jane Doe',
  type: QrType.vCard,
  position: 7,
  info: {
    'firstName': 'Jane',
    'lastName': 'Doe',
    'company': 'Acme Impact',
    'jobTitle': 'Social Impact Advisor',
    'email': 'jane.doe@example.com',
    'phone': '+1-804-222-1111',
    'address': '100 Wellington St;Ottawa ON;K1A 0A9 Canada',
    'website': 'https://example.com',
    'data': 'BEGIN:VCARD\nVERSION:4.0\nFN:Jane Doe\nTITLE:Sales Manager\n'
        'ORG;TYPE=work:Acme Inc.\nEMAIL;TYPE=work:jane.doe@example.com\n'
        'TEL;TYPE=work:+1-804-222-1111\n'
        'ADR;TYPE=work:100 Wellington St;Ottawa ON;K1A 09A Canada\n'
        'URL;TYPE=work:https://example.com\nEND:VCARD',
  },
);
final wifiItem = QrItem(
  title: 'Use My Wi-Fi',
  type: QrType.wifi,
  position: 8,
  info: {
    'type': 'WPA',
    'ssid': 'My SSID',
    'hidden': false,
    'id': null,
    'password': 'super secret password',
    'publicKey': null,
    'data': 'WIFI:T:WPA;S:My%20SSID;P:super%20secrete%20password;;',
  },
);
final textItem = QrItem(
  title: 'Things to Share',
  type: QrType.text,
  position: 9,
  info: {
    'content': 'Lorem ipsum dolor sit amet, consectetur',
    'data': 'Lorem ipsum dolor sit amet, consectetur',
  },
);
// final geoItem = QrItem(
//   title: 'Find My Place',
//   type: QrType.geo,
//   position: 6,
//   info: {
//     'coordinate': '48.2010,16.3695,183',
//     'data': 'geo:48.2010,16.3695,183',
//   },
// );

final demoItems = [
  homepageItem,
  instagramItem,
  twitterItem,
  telItem,
  icalItem,
  smsItem,
  mailtoItem,
  vcardItem,
  wifiItem,
  textItem,
  // geoItem,
];

class SqliteService {
  SqliteService._private();
  static final _instance = SqliteService._private();
  factory SqliteService() {
    return _instance;
  }

  Database? _db;

  Future open() async {
    _db = await openDatabase(
      databaseName,
      version: databaseVersion,
      onCreate: (db, version) async {
        debugPrint('creating database version: $version');
        for (final sql in sqlCreateTables) {
          await db.execute(sql);
        }
        // insert initial data
        for (final item in demoItems) {
          await db.insert(tableQrItems, item.toDatabase());
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        debugPrint('upgrade database from version $oldVersion to $newVersion');
        await db.execute('ALTER TABLE $tableQrItems ADD COLUMN text TEXT');
      },
    );
  }

  Future close() async {
    await _db?.close();
  }

  Future<Database> getDatabase() async {
    if (_db == null) {
      await open();
    }
    return _db!;
  }

  Future<List<QrItem>> getQrItems({Map<String, dynamic>? query}) async {
    final db = await getDatabase();
    final snapshot = await db.query(
      tableQrItems,
      distinct: query?['distict'],
      columns: query?['columns'],
      where: query?['where'],
      whereArgs: query?['whereArgs'],
      groupBy: query?['groupBy'],
      having: query?['having'],
      orderBy: query?['orderBy'],
      limit: query?['limit'],
      offset: query?['offset'],
    );
    final result = snapshot.map((e) => QrItem.fromDatabase(e)).toList();
    return result;
  }

  Future<QrItem> getQrItemById(int id) async {
    final db = await getDatabase();
    final snapshot =
        await db.query(tableQrItems, where: 'id = ?', whereArgs: [id]);

    try {
      return QrItem.fromDatabase(snapshot.first);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<int> addQrItem(QrItem item) async {
    final db = await getDatabase();
    int result;

    // debugPrint('addQrItem: $item');
    if (item.id == null) {
      result = await db.insert(
        tableQrItems,
        item.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      result = await updateQrItem(item);
    }
    return result;
  }

  Future updateQrItem(QrItem item) async {
    final db = await getDatabase();
    int result;

    if (item.id == null) {
      result = await addQrItem(item);
    } else {
      result = await db.update(
        tableQrItems,
        item.toDatabase(),
        where: 'id = ?',
        whereArgs: [item.id],
      );
    }

    return result;
  }

  Future<int> deleteQrItemById(int id) async {
    final db = await getDatabase();
    final result =
        await db.delete(tableQrItems, where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
