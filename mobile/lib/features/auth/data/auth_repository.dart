import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';

class AuthRepository {
  AuthRepository(this._api, this._session);

  final ApiClient _api;
  final SessionStore _session;

  Future<void> login({required String email, required String password}) async {
    final data = await _api.post('/api/login/', body: {'email': email, 'password': password});
    await _session.save(
      token: data['token'] as String,
      userId: '${data['user_id'] ?? ''}',
      userName: data['user_name'] as String?,
      isTherapist: data['is_therapist'] == true,
    );
  }

  Future<void> signup({required String name, required String email, required String password, required String phone}) async {
    await _api.post('/api/signup/', body: {
      'name': name,
      'email': email,
      'password': password,
      'phone_number': phone,
      'is_therapist': false,
    });
  }

  Future<void> logout() async {
    try {
      await _api.post('/api/logout/');
    } finally {
      await _session.clear();
    }
  }
}
