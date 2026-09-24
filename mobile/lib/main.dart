import 'package:flutter/material.dart';

import 'core/session/session_store.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = await SessionStore.create();
  runApp(HearteliApp(sessionStore: session));
}
