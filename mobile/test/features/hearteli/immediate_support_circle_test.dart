import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/network/api_client.dart';
import '../../../lib/core/session/session_store.dart';
import '../../../lib/features/hearteli/presentation/safety_screen.dart';

class _Session extends Fake implements SessionStore {}

class _CircleApi extends Fake implements ApiClient {
  _CircleApi(this.recipients);

  final List<Map<String, dynamic>> recipients;

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    expect(path, '/api/tracking/hearteli/circle/');
    expect(query, {'nudge_eligible': 'true'});
    return recipients;
  }
}

Future<void> _openCircle(
  WidgetTester tester,
  List<Map<String, dynamic>> recipients,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SafetyScreen(
        apiClient: _CircleApi(recipients),
        sessionStore: _Session(),
      ),
    ),
  );
  await tester.tap(find.text('Find local support'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Australia').last);
  await tester.pumpAndSettle();

  final circle = find.text('Contact someone in my Circle');
  await tester.scrollUntilVisible(circle, 120);
  await tester.tap(circle);
  await tester.pumpAndSettle();
  expect(find.widgetWithText(AppBar, 'Your Circle'), findsOneWidget);
  expect(tester.takeException(), isNull);
}

void main() {
  testWidgets('Empty Circle offers a safe return and retains the country', (
    tester,
  ) async {
    await _openCircle(tester, []);
    expect(
      find.text('No trusted Circle contact can receive a Nudge right now.'),
      findsOneWidget,
    );
    final back = find.text('Back to Immediate Support');
    await tester.ensureVisible(back);
    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(find.text('Australia'), findsOneWidget);
    expect(find.text('Emergency services — 000'), findsOneWidget);
  });

  testWidgets('Selecting a trusted contact opens confirmation before sending', (
    tester,
  ) async {
    await _openCircle(tester, [
      {'recipient': 3, 'recipient_name': 'Alex', 'relationship': 'Friend'},
    ]);
    final contact = find.text('Alex');
    await tester.ensureVisible(contact);
    await tester.tap(contact);
    await tester.pumpAndSettle();
    expect(find.text('A little nudge can go a long way'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
