
import 'package:intl/intl.dart';
import 'package:ollama_dart/ollama_dart.dart';

extension ModelExtensions on Model {
  DateTime? get lastUpdate =>
      modifiedAt == null ? null : DateTime.tryParse(modifiedAt!);
  String get formattedLastUpdate =>
      lastUpdate != null ? DateFormat('dd/MM/yyyy').format(lastUpdate!) : '';
}







