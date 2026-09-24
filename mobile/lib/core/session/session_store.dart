import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  SessionStore._(this._preferences, this._secure, this._token);
  static const _secureTokenKey = 'hearteli_auth_token';
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _therapistKey = 'is_therapist';
  final SharedPreferences _preferences;
  final FlutterSecureStorage _secure;
  String? _token;

  static Future<SessionStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    const secure = FlutterSecureStorage();
    return SessionStore._(
      prefs,
      secure,
      await secure.read(key: _secureTokenKey),
    );
  }

  String? get token => _token;
  String? get userId => _preferences.getString(_userIdKey);
  String? get userName => _preferences.getString(_userNameKey);
  bool get isTherapist => _preferences.getBool(_therapistKey) ?? false;
  bool get isAuthenticated => _token?.isNotEmpty == true;
  bool get hasCompletedSetup =>
      _preferences.getBool('hearteli_setup_${userId ?? ''}') ?? false;
  Future<void> completeSetup() async =>
      _preferences.setBool('hearteli_setup_${userId ?? ''}', true);

  Future<void> save({
    required String token,
    String? userId,
    String? userName,
    bool isTherapist = false,
  }) async {
    await _secure.write(key: _secureTokenKey, value: token);
    _token = token;
    if (userId != null) await _preferences.setString(_userIdKey, userId);
    if (userName != null) await _preferences.setString(_userNameKey, userName);
    await _preferences.setBool(_therapistKey, isTherapist);
  }

  Future<void> clear() async {
    await _secure.delete(key: _secureTokenKey);
    _token = null;
    await _preferences.remove(_userIdKey);
    await _preferences.remove(_userNameKey);
    await _preferences.remove(_therapistKey);
  }
}
