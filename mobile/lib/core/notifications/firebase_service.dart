import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../network/api_client.dart';

class FirebaseService {
  FirebaseService(this._apiClient);
  final ApiClient _apiClient;
  static StreamSubscription<String>? _tokens;
  static StreamSubscription<RemoteMessage>? _opens;
  static void Function(int)? _onNudge;

  Future<bool> initialize({
    bool requestPermission = true,
    void Function(int)? onNudge,
  }) async {
    try {
      await Firebase.initializeApp();
      if (onNudge != null) _onNudge = onNudge;
      final permission = requestPermission
          ? await FirebaseMessaging.instance.requestPermission(
              alert: true,
              badge: true,
              sound: true,
            )
          : await FirebaseMessaging.instance.getNotificationSettings();
      if (permission.authorizationStatus != AuthorizationStatus.authorized &&
          permission.authorizationStatus != AuthorizationStatus.provisional)
        return false;
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) await registerToken(token);
      await _tokens?.cancel();
      _tokens = FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        try {
          await registerToken(token);
        } catch (_) {
          /* Re-register on next app open. */
        }
      });
      await _opens?.cancel();
      _opens = FirebaseMessaging.onMessageOpenedApp.listen(openMessage);
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) openMessage(initial);
      return true;
    } catch (_) {
      return false;
    }
  }

  static void openMessage(RemoteMessage message) {
    final id = int.tryParse('${message.data['target_id']}');
    if (id != null &&
        {
          'nudge',
          'acknowledgement',
          'support_message',
          'support_outcome',
        }.contains(message.data['kind']))
      _onNudge?.call(id);
  }

  static Future<void> disconnect() async {
    await _tokens?.cancel();
    await _opens?.cancel();
    _onNudge = null;
  }

  Future<void> registerToken(String token) async {
    await _apiClient.post(
      '/api/users/device-token/',
      body: {'token': token, 'platform': 'flutter'},
    );
  }

  Future<void> unregisterToken(String token) async {
    await _apiClient.delete('/api/users/device-token/', body: {'token': token});
  }
}
