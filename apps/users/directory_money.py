from datetime import date
from decimal import Decimal, InvalidOperation

import requests
from django.conf import settings
from django.core.cache import cache
from django.utils import timezone

MARKETS = {
    'AU': ('Australia', 'AUD'), 'US': ('United States', 'USD'),
    'GB': ('United Kingdom', 'GBP'), 'CA': ('Canada', 'CAD'),
    'NZ': ('New Zealand', 'NZD'), 'PK': ('Pakistan', 'PKR'),
}
CURRENCIES = tuple(sorted({currency for _, currency in MARKETS.values()} | {'EUR'}))


def billing_currency():
    return settings.HEARTELI_CURRENCY.upper()


def reference_rate(source, target):
    if source == target:
        return None
    if source not in (*CURRENCIES, billing_currency()) or target not in CURRENCIES:
        return None
    key = f'hearteli:fx:v2:{source}:{target}'
    value = cache.get(key)
    if value is not None:
        return value or None
    try:
        response = requests.get(
            f'https://api.frankfurter.dev/v2/rate/{source}/{target}',
            timeout=(2, 3),
        )
        response.raise_for_status()
        data = response.json()
        rate = Decimal(str(data['rate']))
        effective = date.fromisoformat(data['date'])
        age = (timezone.now().date() - effective).days
        if data['base'] != source or data['quote'] != target or not rate.is_finite() or not Decimal('0.000000001') <= rate <= Decimal('1000000000') or not 0 <= age <= 7:
            raise ValueError('Invalid reference rate')
        value = {
            'base': source, 'quote': target, 'rate': str(rate), 'date': effective.isoformat(),
            'retrieved_at': timezone.now().isoformat(), 'source': 'Frankfurter',
        }
        cache.set(key, value, 60 * 60 * 12)
        return value
    except (requests.RequestException, ValueError, TypeError, KeyError, InvalidOperation):
        cache.set(key, {}, 60 * 5)
        return None
