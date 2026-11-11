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
  static bool _deviceRegistrationEnabled = true;

  Future<bool> initialize({
    bool requestPermission = true,
    bool registerDevice = true,
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
      _deviceRegistrationEnabled = registerDevice;
      final permission = requestPermission
          ? await FirebaseMessaging.instance.requestPermission(
              alert: true,
              badge: true,
              sound: true,
            )
          : await FirebaseMessaging.instance.getNotificationSettings();
      final permissionGranted =
          permission.authorizationStatus == AuthorizationStatus.authorized ||
          permission.authorizationStatus == AuthorizationStatus.provisional;
      if (registerDevice && permissionGranted) {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null && token.isNotEmpty) await registerToken(token);
      } else {
        await unregisterCurrentToken();
      }
      await _tokens?.cancel();
      _tokens = FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        try {
          if (_deviceRegistrationEnabled) {
            await registerToken(token);
          }
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
      return registerDevice && permissionGranted;
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

  Future<void> unregisterCurrentToken() async {
    _deviceRegistrationEnabled = false;
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null && token.isNotEmpty) await unregisterToken(token);
  }

  Future<bool> notificationPermissionGranted() async {
    if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    final permission =
        await FirebaseMessaging.instance.getNotificationSettings();
    return permission.authorizationStatus == AuthorizationStatus.authorized ||
        permission.authorizationStatus == AuthorizationStatus.provisional;
  }
}
