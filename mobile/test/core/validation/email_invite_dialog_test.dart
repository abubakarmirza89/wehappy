import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/network/api_client.dart';
import '../../../lib/core/validation/form_feedback.dart';

void main() {
  testWidgets('Invite validates before sending and preserves input on failure',
      (tester) async {
    final emails = <String>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EmailInviteDialog(onInvite: (email) async {
          emails.add(email);
          throw const ApiException('internal_validation_key', 400);
        }),
      ),
    ));

    await tester.tap(find.text('Invite'));
    await tester.pump();
    expect(find.text('Enter an email address.'), findsOneWidget);
    expect(emails, isEmpty);
    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
        isTrue);

    await tester.enterText(find.byType(TextField), 'not-an-email');
    await tester.tap(find.text('Invite'));
    await tester.pump();
    expect(find.text('Enter an email address like name@example.com.'), findsOneWidget);
    expect(emails, isEmpty);

    await tester.enterText(find.byType(TextField), 'person@example.com');
    await tester.tap(find.text('Invite'));
    await tester.pump();
    expect(emails, ['person@example.com']);
    expect(find.text('Check the email address and try again.'), findsOneWidget);
    expect(find.text('internal_validation_key'), findsNothing);
    expect(find.text('person@example.com'), findsOneWidget);
  });
}
