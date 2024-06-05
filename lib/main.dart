
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'root_provider.dart';
import 'util/db.dart';
import 'util/log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initLog();

  final prefs = await SharedPreferences.getInstance();
  final db = await initDB();
  runApp(
    RootProvider(
      prefs: prefs,
      db: db,
      child: const App(),
    ),
  );

}
