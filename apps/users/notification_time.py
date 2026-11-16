from datetime import datetime, timedelta, timezone
from functools import lru_cache
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError, available_timezones


@lru_cache(maxsize=1)
def notification_timezone_names():
    return frozenset(available_timezones()) | {'UTC'}


def notification_zone(name):
    try:
        return ZoneInfo(name)
    except (ZoneInfoNotFoundError, ValueError):
        return ZoneInfo('UTC')


def reminder_occurrences(day, wall_time, zone):
    """Pick both overlap instants and the first valid minute after a DST gap."""
    local = datetime.combine(day, wall_time.replace(second=0, microsecond=0))
    for shift in range(181):
        candidate = local + timedelta(minutes=shift)
        if candidate.date() != day:
            break
        instants = {
            instant for fold in (0, 1)
            if (instant := candidate.replace(tzinfo=zone, fold=fold).astimezone(timezone.utc))
            .astimezone(zone).replace(tzinfo=None) == candidate
        }
        if instants:
            return instants
    return set()
