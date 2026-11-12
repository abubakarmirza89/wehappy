import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../session/session_store.dart';

class ApiException implements Exception {
  const ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this._sessionStore, {http.Client? client}) : _client = client ?? http.Client();

  final SessionStore _sessionStore;
  final http.Client _client;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final base = AppConfig.apiBaseUrl.endsWith('/')
        ? AppConfig.apiBaseUrl.substring(0, AppConfig.apiBaseUrl.length - 1)
        : AppConfig.apiBaseUrl;
    return Uri.parse('$base$path').replace(
      queryParameters: query?.map((key, value) => MapEntry(key, '$value')),
    );
  }

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (_sessionStore.token?.isNotEmpty == true)
          'Authorization': 'Token ${_sessionStore.token}',
      };

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _client.get(_uri(path, query), headers: _headers);
    return _decode(response);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final response = await _client.post(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body ?? const {}),
    );
    return _decode(response);
  }

  Future<Uint8List> downloadPersonalData(String password) async {
    final token = _sessionStore.token;
    final response = await _client.post(
      _uri('/api/tracking/hearteli/data/export/'),
      headers: {..._headers, 'Accept': 'application/zip, application/json'},
      body: jsonEncode({'password': password}),
    ).timeout(const Duration(seconds: 90));
    if (token == null || token != _sessionStore.token) {
      throw const ApiException('Sign in again.', 401);
    }
    if (response.statusCode != 200) _decode(response);
    final bytes = response.bodyBytes;
    if (response.headers['content-type']?.startsWith('application/zip') != true ||
        bytes.length < 4 || bytes[0] != 0x50 || bytes[1] != 0x4b) {
      throw const ApiException('Could not prepare the archive.', 500);
    }
    return bytes;
  }

  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) async {
    final response = await _client.patch(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body ?? const {}),
    );
    return _decode(response);
  }

  Future<dynamic> delete(String path, {Map<String, dynamic>? body}) async {
    final response = await _client.delete(
      _uri(path),
      headers: _headers,
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    dynamic data;
    try {
      data = response.body.isEmpty ? null : jsonDecode(response.body);
    } catch (_) {
      data = response.body;
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = data is Map<String, dynamic>
          ? (data['detail'] ?? data['error'] ?? data.values.firstOrNull ?? 'Request failed')
          : 'Request failed';
      throw ApiException('$message', response.statusCode);
    }
    return data;
  }
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
