import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../async_result.dart';
import '../util/db.dart';
import '../models/persona.dart';

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

  Persona generatePersonaPrompt(Persona persona){
    persona.prompt = '''
    Tu es un personnage nommé ${persona.name}. 
    Tu as une passion pour ${persona.hobby} et cela influence ta façon de penser et de te comporter. 
    Ta personnalité est ${persona.personality}.
    Tu travaille en tant que ${persona.job}, ce qui implique que vous avez des compétences et des connaissances spécifiques dans ce domaine. 
    Utilise ces traits pour guider vos réponses et interactions.
    Tu répondra toujours en langue française en utilisant le Markdown.    
     ''';

    return persona;
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
    defaultPersona.value = resp.where((p) => p.isDefault == 1).firstOrNull;
  }

  Future<List<Persona>> findPersonas() async {
    final rawPersona =
    await _db.query(Table.persona.name, orderBy: 'name DESC');
    return rawPersona.map(Persona.fromMap).toList();
  }
}
