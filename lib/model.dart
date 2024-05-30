import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:uuid/uuid.dart';

extension ModelExtensions on Model {
  DateTime? get lastUpdate =>
      modifiedAt == null ? null : DateTime.tryParse(modifiedAt!);

  String get formattedLastUpdate =>
      lastUpdate != null ? DateFormat('dd/MM/yyyy').format(lastUpdate!) : '';
}

class Persona {
  final String id;
  final DateTime lastUpdate;
  final String name;
  final String prompt;
  final String portraitId;
  final String hobby;
  final String personality;
  final String job;
  final List<String> userProperties;

  String get formattedDate => DateFormat('dd/MM/yyyy').format(lastUpdate);

  Persona({
    required this.name,
    required this.lastUpdate,
    required this.prompt,
    required this.hobby,
    required this.personality,
    required this.job,
    required this.userProperties,
    String? portraitId,
    String? id,
  })  : id = id ?? const Uuid().v4(),
        portraitId = portraitId ?? const Uuid().v4();

  @override
  String toString() {
    return 'Persona{id: $id, lastUpdate: $lastUpdate,name: $name, prompt: $prompt, portraitId: $portraitId, hobby: $hobby, job: $job, personality: $personality, userProperties: $userProperties}';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'prompt': prompt,
        'lastUpdate': lastUpdate.toIso8601String(),
        'portraitId': portraitId,
        'hobby': hobby,
        'job': job,
        'personality': personality,
        'userProperties': jsonEncode(userProperties),
      };

  factory Persona.fromMap(Map<String, dynamic> data) {

    return Persona(
      id: data['id'],
      lastUpdate: DateTime.parse(data['lastUpdate']),
      name: data['name'],
      portraitId: data['portraitId'],
      prompt: data['prompt'],
      hobby: data['hobby'],
      job: data['job'],
      personality: data['personality'],
      userProperties: List.from(jsonDecode(data['userProperties'])),
    );
  }
}

class Conversation {
  final String id;

  final String model;

  final double temperature;

  final DateTime lastUpdate;

  String get formattedDate => DateFormat('dd/MM/yyyy').format(lastUpdate);

  final String title;

  final List<(String, String)> messages;

  Conversation({
    required this.lastUpdate,
    required this.model,
    required this.title,
    required this.messages,
    this.temperature = 1.0,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'model': model,
        'temperature': temperature,
        'lastUpdate': lastUpdate.toIso8601String(),
        'title': title,
        'messages': jsonEncode(
          messages.map((e) => [e.$1, e.$2]).toList(),
        ),
      };

  factory Conversation.fromMap(Map<String, dynamic> data) {
    final messages = List.from(jsonDecode(data['messages']))
        .map((e) => List<String>.from(e))
        .map((e) => (e.first, e.last))
        .toList();

    return Conversation(
      id: data['id'],
      model: data['model'],
      temperature: data['temperature'],
      lastUpdate: DateTime.parse(data['lastUpdate']),
      title: data['title'],
      messages: messages,
    );
  }

  Conversation copyWith({
    String? newTitle,
    List<(String, String)>? newMessages,
  }) =>
      Conversation(
        id: id,
        model: model,
        lastUpdate: lastUpdate,
        title: newTitle ?? title,
        messages: newMessages ?? messages,
      );

  @override
  String toString() {
    return 'Conversation{id: $id, model: $model, temperature: $temperature, lastUpdate: $lastUpdate, title: $title, messages: $messages}';
  }
}
