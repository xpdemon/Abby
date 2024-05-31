import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Persona {
  final String id;
  final DateTime lastUpdate;
  final String name;
  late String prompt;
  final String portraitId;
  final String hobby;
  final String personality;
  final String job;
  late List<String> userProperties;
  final int isDefault;

  String get formattedDate => DateFormat('dd/MM/yyyy').format(lastUpdate);

  Persona({
    required this.name,
    required this.lastUpdate,
    required this.hobby,
    required this.personality,
    required this.job,
    required this.isDefault,
    String? prompt,
    String? portraitId,
    String? id,
    List<String>? userProperties,
  })  : id = id ?? const Uuid().v4(),
        portraitId = portraitId ?? const Uuid().v4(),
        userProperties = userProperties ?? List.empty(),
        prompt = prompt ?? '';

  @override
  String toString() {
    return 'Persona{id: $id, lastUpdate: $lastUpdate,name: $name, prompt: $prompt, portraitId: $portraitId, hobby: $hobby, job: $job, personality: $personality, userProperties: $userProperties, isDefault: $isDefault}';
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
    'isDefault': isDefault.toString(),
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
      isDefault: data['isDefault'],
    );
  }
}