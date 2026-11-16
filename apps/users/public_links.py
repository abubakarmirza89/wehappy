from urllib.parse import urlsplit

from django.conf import settings


def secure_url(value, *, host=None):
    try:
        url = urlsplit(value)
        if url.scheme == 'https' and url.hostname and not (url.username or url.password):
            if host is None or url.hostname == host:
                return value
    except ValueError:
        pass
    return ''


def public_links(request):
    return {
        'play_store_url': secure_url(settings.HEARTELI_PLAY_STORE_URL, host='play.google.com'),
        'terms_url': secure_url(settings.HEARTELI_TERMS_URL),
    }
