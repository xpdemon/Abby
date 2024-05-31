import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


const dbFileName = 'db.db';

final _log = Logger('Db');

enum Table { conversation, persona }

/// sqlite DB abstraction
Future<Database> initDB() async {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
    const dirPath = '/assets/db';
    final path = join(dirPath, dbFileName);
    _log.info('DbPath : $path');
    return openDatabase(path, onCreate: _createDb, version: 1);
  } else {
    databaseFactory = databaseFactoryFfi;
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, dbFileName);
    _log.info('DbPath : $path');
    return openDatabase(path, onCreate: _createDb, version: 1);
  }
}

Future<void> _createDb(Database db, [int? version]) async {
  db
    ..execute('''
CREATE TABLE IF NOT EXISTS ${Table.conversation.name}(
  id TEXT NOT NULL PRIMARY KEY,
  model TEXT NOT NULL,
  temperature REAL NOT NULL,
  lastUpdate TEXT NOT NULL,
  title TEXT NOT NULL,
  messages TEXT
)
''')
    ..execute('''
CREATE TABLE IF NOT EXISTS ${Table.persona.name}(
  id TEXT NOT NULL PRIMARY KEY,    
  lastUpdate TEXT NOT NULL,
  name TEXT,
  prompt TEXT,
  portraitId TEXT,
  hobby TEXT,
  personality TEXT,
  job TEXT,
  userProperties TEXT,
  isDefault INTEGER
)

''');
}
