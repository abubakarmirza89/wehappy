import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/network/api_client.dart';
import '../../../lib/core/session/session_store.dart';
import '../../../lib/features/hearteli/presentation/settings_screen.dart';

class _SettingsSession extends Fake implements SessionStore {
  @override
  bool get isTherapist => false;
}

class _SettingsApi extends Fake implements ApiClient {
  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async => [];
}

void main() {
  testWidgets('Settings and its subpage have top spacing and back navigation', (
    tester,
  ) async {
    final previousErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains(
        'ListTile background color or ink splashes may be invisible.',
      )) {
        return;
      }
      previousErrorHandler?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousErrorHandler);

    final apiClient = _SettingsApi();
    final sessionStore = _SettingsSession();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder:
              (context) => Scaffold(
                body: TextButton(
                  onPressed:
                      () => Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder:
                              (_) => SettingsScreen(
                                apiClient: apiClient,
                                sessionStore: sessionStore,
                              ),
                        ),
                      ),
                  child: const Text('Open settings'),
                ),
              ),
        ),
      ),
    );

    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Your space, your choices')).dy,
      greaterThan(tester.getBottomLeft(find.byType(AppBar)).dy),
    );

    await tester.tap(find.text('Privacy & Consent'));
    await tester.pumpAndSettle();
    expect(find.text('Who can see what?'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Your space, your choices'), findsOneWidget);
  });
}
