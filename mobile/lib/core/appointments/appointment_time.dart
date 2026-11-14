import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../network/api_client.dart';

class AppointmentClock {
  static bool _initialized = false;
  final tz.Location? _location;

  AppointmentClock._(this._location);

  factory AppointmentClock.forZone(Object? zone) {
    if (zone is! String || zone.isEmpty) return AppointmentClock._(null);
    if (!_initialized) {
      tz_data.initializeTimeZones();
      _initialized = true;
    }
    return AppointmentClock._(tz.getLocation(zone));
  }

  static Future<AppointmentClock> load(ApiClient apiClient) async {
    final prefs = await apiClient.get('/api/tracking/hearteli/preferences/');
    final zone = prefs['timezone_name'];
    return AppointmentClock.forZone(
      prefs['timezone_selected'] == true || zone != 'UTC' ? zone : null,
    );
  }

  DateTime get today {
    final location = _location;
    final now = location == null ? DateTime.now() : tz.TZDateTime.now(location);
    return DateTime(now.year, now.month, now.day);
  }

  String get label => _location?.name ?? 'Device timezone';

  DateTime? resolve(DateTime date, TimeOfDay time) {
    final location = _location;
    final local = location == null
        ? DateTime(date.year, date.month, date.day, time.hour, time.minute)
        : tz.TZDateTime(
            location,
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
    // Do not silently shift a non-existent time during a daylight-saving jump.
    if (local.year != date.year ||
        local.month != date.month ||
        local.day != date.day ||
        local.hour != time.hour ||
        local.minute != time.minute)
      return null;
    return local;
  }

  String describe(DateTime value) =>
      '${value.year}-${_two(value.month)}-${_two(value.day)} at '
      '${_two(value.hour)}:${_two(value.minute)} '
      '(${_location?.name ?? 'Device timezone'} · ${value.timeZoneName})';
}

String _two(int value) => value.toString().padLeft(2, '0');

Map<String, String> appointmentUtcPayload(DateTime value) {
  final utc = value.toUtc();
  return {
    'date': utc.toIso8601String().substring(0, 10),
    'time': '${_two(utc.hour)}:${_two(utc.minute)}',
  };
}

String appointmentDisplayTime(Map appointment) {
  final display = appointment['display_time'];
  if (display is Map && display['timezone'] is String) {
    final zone = display['timezone'];
    final abbreviation = display['abbreviation'];
    return '${display['local_date']} · ${display['local_time']} '
        '${zone == abbreviation ? zone : '$zone ($abbreviation)'}';
  }
  final utc = DateTime.tryParse(
    '${display is Map ? display['starts_at'] : "${appointment['date']}T${appointment['time']}Z"}',
  );
  if (utc != null)
    return AppointmentClock.forZone(null).describe(utc.toLocal());
  return '${appointment['date']} · ${appointment['time']} UTC';
}
