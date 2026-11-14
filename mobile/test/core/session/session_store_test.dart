import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../lib/core/session/session_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'user_id': '12',
      'user_name': 'Restored user',
      'is_therapist': true,
      'hearteli_setup_12': true,
    });
  });

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test(
    'unreadable restored token opens signed out without clearing other data',
    () async {
      final deleted = <Object?>[];
      messenger.setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'read') throw PlatformException(code: 'unwrap');
        if (call.method == 'delete') {
          deleted.add((call.arguments as Map)['key']);
          throw PlatformException(code: 'unavailable');
        }
        fail('Unexpected secure storage operation: ${call.method}');
      });

      final session = await SessionStore.create();
      expect(session.isAuthenticated, isFalse);
      expect(session.userId, isNull);
      expect(session.userName, isNull);
      expect(session.isTherapist, isFalse);
      expect(deleted, ['hearteli_auth_token']);
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getBool('hearteli_setup_12'), isTrue);
    },
  );

  test('a readable token still restores the existing session', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'read');
      return 'valid-token';
    });

    final session = await SessionStore.create();
    expect(session.isAuthenticated, isTrue);
    expect(session.userId, '12');
    expect(session.isTherapist, isTrue);
    expect(session.hasCompletedSetup, isTrue);
  });
}
