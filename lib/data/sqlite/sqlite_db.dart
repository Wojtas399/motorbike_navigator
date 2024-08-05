import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@injectable
class SqliteDb {
  Future<String> get dbPath async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, 'motorbike_navigator.db');
  }
}
