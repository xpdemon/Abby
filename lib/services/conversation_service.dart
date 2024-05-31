import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../util/db.dart';
import '../models/conversation.dart';

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
