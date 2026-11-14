import 'package:flutter/material.dart';

import 'app.dart';
import 'core/session/session_store.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _Startup());
}

class _Startup extends StatefulWidget {
  const _Startup();

  @override
  State<_Startup> createState() => _StartupState();
}

class _StartupState extends State<_Startup> {
  late Future<SessionStore> _session = _loadSession();

  Future<SessionStore> _loadSession() =>
      SessionStore.create().timeout(const Duration(seconds: 10));

  @override
  Widget build(BuildContext context) => FutureBuilder<SessionStore>(
    future: _session,
    builder: (context, snapshot) {
      final session = snapshot.data;
      if (session != null) return HearteliApp(sessionStore: session);
      return MaterialApp(
        title: 'Hearteli',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(
            child: snapshot.hasError
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Hearteli couldn’t start.'),
                      TextButton(
                        onPressed: () =>
                            setState(() => _session = _loadSession()),
                        child: const Text('Try again'),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(
                    semanticsLabel: 'Opening Hearteli',
                  ),
          ),
        ),
      );
    },
  );
}
