import 'package:provider/provider.dart';
import 'package:qree/data/service/sqflite.dart';

import '../ui/home/model.dart';
import '../ui/qritem/model.dart';

final providers = [
  Provider(create: (context) => SqliteService()),
  ChangeNotifierProvider(
    create: (context) => HomeViewModel(db: context.read<SqliteService>()),
  ),
  ChangeNotifierProvider(
    create: (context) => QrItemViewModel(db: context.read<SqliteService>()),
  ),
];
