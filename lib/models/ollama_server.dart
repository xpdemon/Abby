import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class OllamaServer {
  final String id;
  final String name;
  final String url;
  late DateTime lastUse;

  String get formattedDate => DateFormat('yyyy-MM-dd hh:mm:ss').format(lastUse);

  OllamaServer({
    required this.name,
    String? id,
    required this.url,
    DateTime? lastUse,
  })  : id = id ?? const Uuid().v4(),
        lastUse = lastUse ?? DateTime.now();

  @override
  String toString() {
    return 'OallamaServer{id: $id, url: $url, lastUse: $lastUse, name: $name}';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'url': url,
        'lastUse': formattedDate,
      };

  factory OllamaServer.fromMap(Map<String, dynamic> data) {
    return OllamaServer(
      name: data['name'],
      url: data['url'],
      lastUse: DateTime.parse(data['lastUse']),
      id: data['id'],
    );
  }
}
