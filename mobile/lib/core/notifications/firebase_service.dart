import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../network/api_client.dart';

class FirebaseService {
  FirebaseService(this._apiClient);

  final ApiClient _apiClient;

  Future<bool> initialize() async {
    try {
      await Firebase.initializeApp();
      await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) await registerToken(token);
      FirebaseMessaging.instance.onTokenRefresh.listen(registerToken);
      return true;
    } on FirebaseException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> registerToken(String token) async {
    await _apiClient.post('/api/users/device-token/', body: {
      'token': token,
      'platform': 'flutter',
    });
  }

  Future<void> unregisterToken(String token) async {
    await _apiClient.delete('/api/users/device-token/', body: {'token': token});
  }
}
