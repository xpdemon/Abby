import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../async_result.dart';
import '../models/ollama_server.dart';
import '../util/db.dart';

class OllamaServerService {
  final Database _db;
  final SharedPreferences prefs;
  final ValueNotifier<OllamaServer?> currentServer = ValueNotifier(null);

  final ValueNotifier<AsyncData<List<OllamaServer>>> ollamaServers =
      ValueNotifier(const Data([]));

  OllamaServerService(this._db, this.prefs);

  Future<void> init() async {
    await loadServers();
  }

  Future<List<OllamaServer>> getAllServers() async {
    final rawServer =
        await _db.query(Table.ollamaServer.name, orderBy: 'lastUse DESC');
    return rawServer.map(OllamaServer.fromMap).toList();
  }

  Future<void> loadServers() async {
    ollamaServers.value = const Pending();
    final resp = await getAllServers();
    resp.sort((a, b) => b.lastUse.compareTo(a.lastUse));
    ollamaServers.value = Data(resp);
    currentServer.value = resp.first;
    selectServer(currentServer.value);
  }

  Future<int> addServer(OllamaServer server) async {
    selectServer(server);
    ollamaServers.value.data?.add(server);
    return _db.insert(
      Table.ollamaServer.name,
      server.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateServer(OllamaServer server) async {
    server.lastUse = DateTime.now();
    _db.insert(
      Table.ollamaServer.name,
      server.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> selectServer(final OllamaServer? server) async {
    if (server == null) return;
    updateServer(server);

    (await SharedPreferences.getInstance())
        .setString('currentServer', server.url);
    currentServer.value = server;
  }

  Future<void> deleteServer(OllamaServer? server) async {
    if (server == null) return;

    _db.delete(
      Table.ollamaServer.name,
      where: 'id = ?',
      whereArgs: [server.id],
    );
  }

  String verifyServerUrl(String serverUrl) {
    return serverUrl.startsWith(RegExp(r'^((http|https)://)(.*)$'))
        ? serverUrl
        : 'http://${serverUrl}';
  }
}
