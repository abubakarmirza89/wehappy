import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'core/session/session_store.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/app_shell.dart';

class MindMentaApp extends StatelessWidget {
  const MindMentaApp({super.key, required this.sessionStore});

  final SessionStore sessionStore;

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(sessionStore);
    return MaterialApp(
      title: 'MindMenta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: sessionStore.isAuthenticated
          ? AppShell(sessionStore: sessionStore, apiClient: apiClient)
          : LoginScreen(sessionStore: sessionStore, apiClient: apiClient),
    );
  }
}
