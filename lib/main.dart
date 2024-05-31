
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'util/db.dart';
import 'util/log.dart';
import 'root_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initLog();

  final prefs = await SharedPreferences.getInstance();
  final db = await initDB();
  runApp(
    RootProvider(
      prefs: prefs,
      db: db,
      ollamaBaseUrl: 'http://127.0.0.1:11434/api',
      child: const App(),
    ),
  );

}
