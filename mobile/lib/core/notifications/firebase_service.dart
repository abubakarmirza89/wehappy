import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
  static final _pushRegistration = ValueNotifier<bool?>(null);
  static ValueListenable<bool?> get pushRegistration => _pushRegistration;
  static const _notificationSettings = MethodChannel(
    'hearteli/notification_settings',
  );
  static bool get canOpenDeviceSettings =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static Future<void> openDeviceSettings() =>
      _notificationSettings.invokeMethod<void>('open');

  Future<bool> initialize({
    bool requestPermission = true,
    bool registerDevice = true,
    void Function(int)? onNudge,
    void Function(String, String)? onForegroundNotification,
  }) async {
    try {
      _deviceRegistrationEnabled = registerDevice;
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      if (onNudge != null) _onNudge = onNudge;
      if (onForegroundNotification != null) {
        _onForegroundNotification = onForegroundNotification;
      }
      final permission =
          requestPermission
              ? await FirebaseMessaging.instance.requestPermission(
                alert: true,
                badge: true,
                sound: true,
              )
              : await FirebaseMessaging.instance.getNotificationSettings();
      final permissionGranted =
          permission.authorizationStatus == AuthorizationStatus.authorized ||
          permission.authorizationStatus == AuthorizationStatus.provisional;
      var registered = false;
      if (registerDevice && permissionGranted) {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null && token.isNotEmpty) {
          await registerToken(token);
          registered = true;
        }
      } else if (!registerDevice || !permissionGranted) {
        await unregisterCurrentToken();
      }
      await _tokens?.cancel();
      _tokens = FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        try {
          if (_deviceRegistrationEnabled) {
            await registerToken(token);
            _pushRegistration.value = true;
          }
        } catch (error, stackTrace) {
          if (_deviceRegistrationEnabled) _pushRegistration.value = false;
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
      _pushRegistration.value =
          registerDevice && permissionGranted ? registered : null;
      return registered;
    } catch (error, stackTrace) {
      _pushRegistration.value = registerDevice ? false : null;
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
    _pushRegistration.value = null;
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
    final wasEnabled = _deviceRegistrationEnabled;
    _deviceRegistrationEnabled = false;
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) await unregisterToken(token);
      _pushRegistration.value = null;
    } catch (_) {
      _deviceRegistrationEnabled = wasEnabled;
      rethrow;
    }
  }

  Future<bool> notificationPermissionGranted() async {
    if (canOpenDeviceSettings) {
      final enabled = await _notificationSettings.invokeMethod<bool>('enabled');
      if (enabled != null) return enabled;
    }
    if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    final permission =
        await FirebaseMessaging.instance.getNotificationSettings();
    return permission.authorizationStatus == AuthorizationStatus.authorized ||
        permission.authorizationStatus == AuthorizationStatus.provisional;
  }
}
