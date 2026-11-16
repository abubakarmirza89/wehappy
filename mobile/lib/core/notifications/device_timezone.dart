import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../network/api_client.dart';

Future<String?> readDeviceTimezone() async {
  try {
    return await const MethodChannel('hearteli/device_timezone')
        .invokeMethod<String>('get');
  } catch (_) {
    return null;
  }
}

Future<dynamic> syncDeviceTimezone(ApiClient api) async {
  final zone = await readDeviceTimezone();
  if (zone == null) return null;
  try {
    return await api.patch('/api/tracking/hearteli/preferences/device_timezone/',
        body: {'timezone_name': zone});
  } catch (_) {
    // Preserve the last known zone offline. Retry on the next foreground event.
    return null;
  }
}

bool _zoneDataReady = false;

String timezoneLabel(String zone) {
  final parts = zone.replaceAll('_', ' ').split('/');
  final city = parts.last;
  try {
    if (!_zoneDataReady) {
      tz_data.initializeTimeZones();
      _zoneDataReady = true;
    }
    final minutes = tz.TZDateTime.now(tz.getLocation(zone)).timeZoneOffset.inMinutes;
    final duration = minutes.abs();
    final hours = (duration ~/ 60).toString().padLeft(2, '0');
    final rest = (duration % 60).toString().padLeft(2, '0');
    return '$city · GMT${minutes >= 0 ? '+' : '-'}$hours:$rest';
  } catch (_) {
    return city;
  }
}
