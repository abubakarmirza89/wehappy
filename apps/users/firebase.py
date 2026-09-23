import logging

from django.conf import settings

logger = logging.getLogger(__name__)


def send_push_notification(tokens, title, body, data=None):
    """Send FCM notifications when Firebase Admin credentials are configured."""
    if not settings.FIREBASE_CREDENTIALS_PATH:
        return {'sent': 0, 'skipped': len(tokens), 'configured': False}

    try:
        import firebase_admin
        from firebase_admin import credentials, messaging

        if not firebase_admin._apps:
            firebase_admin.initialize_app(credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH))

        messages = [messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            data={str(key): str(value) for key, value in (data or {}).items()},
            token=token,
        ) for token in tokens]
        sent = 0
        for message in messages:
            try:
                messaging.send(message)
                sent += 1
            except Exception:
                logger.exception('FCM delivery failed for one device token')
        return {'sent': sent, 'skipped': len(tokens) - sent, 'configured': True}
    except ImportError:
        logger.warning('firebase-admin is not installed; push delivery skipped')
        return {'sent': 0, 'skipped': len(tokens), 'configured': False}
