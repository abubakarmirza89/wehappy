import 'package:flutter/material.dart';

import '../core/network/api_client.dart';
import '../core/session/session_store.dart';
import '../features/auth/presentation/login_screen.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SessionStore>(
      future: SessionStore.create(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final session = snapshot.data!;
        return LoginScreen(sessionStore: session, apiClient: ApiClient(session));
      },
    );
  }
}
