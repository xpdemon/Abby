import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'async_result.dart';
import 'model.dart';

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
  prompt TEXT
  portraitId TEXT,
  hobby TEXT,
  personality TEXT,
  job TEXT,
  userProperties TEXT,
  isDefault BOOLEAN
)

''');
}

class PersonaService {
  final Database _db;
  final SharedPreferences prefs;

  final ValueNotifier<AsyncData<List<Persona>>> personas =
      ValueNotifier(const Data([]));

  final ValueNotifier<Persona?> defaultPersona = ValueNotifier(null);

  PersonaService(this._db, this.prefs);

  Future<void> init() async {
    await loadPersonas();
  }

  Future<void> selectPersona(final Persona? persona) async {
    if (persona == null) return;

    (await SharedPreferences.getInstance())
        .setString('currentPersona', persona.name);
    defaultPersona.value = persona;
  }

  Future<void> savePersona(Persona persona) async {
    await _db.insert(
      Table.persona.name,
      persona.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePersona(Persona persona) async {
    await _db.delete(
      Table.persona.name,
      where: 'id = ?',
      whereArgs: [persona.id],
    );
  }

  Future<Persona> findPersonaByDefault() async {
    final rawPersona = await _db.query(
      Table.persona.name,
      where: 'isDefault = true',
    );
    return rawPersona.map(Persona.fromMap).first;
  }

  Future<void> loadPersonas() async {
    personas.value = const Pending();
    final resp = await findPersonas();
    personas.value = Data(resp);
    defaultPersona.value = resp.where((p) => p.isDefault).firstOrNull;
  }

  Future<List<Persona>> findPersonas() async {
    final rawPersona =
        await _db.query(Table.persona.name, orderBy: 'name DESC');
    return rawPersona.map(Persona.fromMap).toList();
  }
}

class ConversationService {
  final Database _db;

  ConversationService(this._db);

  Future<void> saveConversation(Conversation conversation) async {
    await _db.insert(
      Table.conversation.name,
      conversation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteConversation(Conversation conversation) async {
    await _db.delete(
      Table.conversation.name,
      where: 'id = ?',
      whereArgs: [conversation.id],
    );
  }

  Future<List<Conversation>> loadConversations() async {
    final rawConversations =
        await _db.query(Table.conversation.name, orderBy: 'lastUpdate DESC');

    return rawConversations.map(Conversation.fromMap).toList();
  }
}
