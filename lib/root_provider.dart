import 'package:flutter/material.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'controller/model_controller.dart';
import 'services/conversation_service.dart';
import 'services/persona_service.dart';
import 'util/theme.dart';

class RootProvider extends StatefulWidget {
  final SharedPreferences prefs;

  final Database db;

  final String? ollamaBaseUrl;

  final Widget child;

  const RootProvider({
    required this.child,
    required this.prefs,
    required this.db,
    this.ollamaBaseUrl,
    super.key,
  });

  @override
  State<RootProvider> createState() => _RootProviderState();
}

class _RootProviderState extends State<RootProvider> {
  late final ollamaClient = OllamaClient(baseUrl: widget.ollamaBaseUrl);

  late final ConversationService conversationService =
      ConversationService(widget.db);

  late final PersonaService personaService = PersonaService(widget.db, widget.prefs)..init();

  late final modelController = ModelController(
    client: ollamaClient,
    prefs: widget.prefs,
  )..init();

  @override
  Widget build(final BuildContext context) => MultiProvider(
        providers: [
          Provider.value(value: ollamaClient),
          Provider.value(value: conversationService),
          Provider.value(value: widget.prefs),
          Provider.value(value: modelController),
          Provider.value(value: personaService),
          ChangeNotifierProvider(
            create: (context) => ThemeController(Brightness.dark),
          ),
        ],
        child: widget.child,
      );
}
