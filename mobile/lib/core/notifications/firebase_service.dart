import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../network/api_client.dart';

class FirebaseService {
  FirebaseService(this._apiClient);
  final ApiClient _apiClient;
  static StreamSubscription<String>? _tokens;
  static StreamSubscription<RemoteMessage>? _opens;
  static StreamSubscription<RemoteMessage>? _messages;
  static void Function(int)? _onNudge;
  static void Function(String, String)? _onForegroundNotification;

  Future<bool> initialize({
    bool requestPermission = true,
    void Function(int)? onNudge,
    void Function(String, String)? onForegroundNotification,
  }) async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      if (onNudge != null) _onNudge = onNudge;
      if (onForegroundNotification != null) {
        _onForegroundNotification = onForegroundNotification;
      }
      final permission = requestPermission
          ? await FirebaseMessaging.instance.requestPermission(
              alert: true,
              badge: true,
              sound: true,
            )
          : await FirebaseMessaging.instance.getNotificationSettings();
      if (permission.authorizationStatus != AuthorizationStatus.authorized &&
          permission.authorizationStatus != AuthorizationStatus.provisional) {
        return false;
      }
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) await registerToken(token);
      await _tokens?.cancel();
      _tokens = FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        try {
          await registerToken(token);
        } catch (error, stackTrace) {
          developer.log(
            'Unable to register refreshed Firebase token',
            name: 'hearteli.notifications',
            error: error,
            stackTrace: stackTrace,
          );
        }
      });
      await _opens?.cancel();
      _opens = FirebaseMessaging.onMessageOpenedApp.listen(openMessage);
      await _messages?.cancel();
      _messages = FirebaseMessaging.onMessage.listen((message) {
        final notification = message.notification;
        _onForegroundNotification?.call(
          notification?.title ?? 'Hearteli',
          notification?.body ?? 'You have a new update.',
        );
      });
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) openMessage(initial);
      return true;
    } catch (error, stackTrace) {
      developer.log(
        'Firebase notification initialization failed',
        name: 'hearteli.notifications',
        error: error,
        stackTrace: stackTrace,
      );
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
        }.contains(message.data['kind'])) {
      _onNudge?.call(id);
    }
  }

  static Future<void> disconnect() async {
    await _tokens?.cancel();
    await _opens?.cancel();
    await _messages?.cancel();
    _onNudge = null;
    _onForegroundNotification = null;
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
