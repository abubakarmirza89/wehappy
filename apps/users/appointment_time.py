"""Render appointments without changing the legacy UTC storage contract."""
from datetime import date, datetime, time, timezone
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError


def appointment_start(appointment):
    day, clock = appointment.date, appointment.time
    # Django model instances may retain ISO strings until reloaded after save.
    if isinstance(day, str):
        day = date.fromisoformat(day)
    if isinstance(clock, str):
        clock = time.fromisoformat(clock)
    return datetime.combine(day, clock, timezone.utc)


def appointment_zone(user):
    if user is None:
        return None
    try:
        preferences = user.hearteli_preferences
        if preferences.timezone_name == "UTC" and not preferences.timezone_selected:
            return None
        return ZoneInfo(preferences.timezone_name)
    except (AttributeError, ValueError, ZoneInfoNotFoundError):
        return None


def local_appointment(appointment, user):
    start = appointment_start(appointment)
    zone = appointment_zone(user)
    local = start.astimezone(zone) if zone else start
    return {
        'starts_at': start.isoformat(),
        'local_date': local.date().isoformat(),
        'local_time': local.strftime('%H:%M'),
        'timezone': zone.key if zone else None,
        'abbreviation': local.tzname(),
        'source_timezone': appointment.provider_timezone or None,
    }


def appointment_time_text(appointment, user):
    value = local_appointment(appointment, user)
    label = value['timezone'] or 'UTC'
    if value['abbreviation'] != label:
        label += f" ({value['abbreviation']})"
    return f"{value['local_date']} at {value['local_time']} {label}"
