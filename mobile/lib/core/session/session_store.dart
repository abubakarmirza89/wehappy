import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  SessionStore._(this._preferences);

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _therapistKey = 'is_therapist';

  final SharedPreferences _preferences;

  static Future<SessionStore> create() async {
    return SessionStore._(await SharedPreferences.getInstance());
  }

  String? get token => _preferences.getString(_tokenKey);
  String? get userId => _preferences.getString(_userIdKey);
  String? get userName => _preferences.getString(_userNameKey);
  bool get isTherapist => _preferences.getBool(_therapistKey) ?? false;
  bool get isAuthenticated => token?.isNotEmpty == true;

  Future<void> save({required String token, String? userId, String? userName, bool isTherapist = false}) async {
    await _preferences.setString(_tokenKey, token);
    if (userId != null) await _preferences.setString(_userIdKey, userId);
    if (userName != null) await _preferences.setString(_userNameKey, userName);
    await _preferences.setBool(_therapistKey, isTherapist);
  }

  Future<void> clear() async {
    await _preferences.remove(_tokenKey);
    await _preferences.remove(_userIdKey);
    await _preferences.remove(_userNameKey);
    await _preferences.remove(_therapistKey);
  }
}
