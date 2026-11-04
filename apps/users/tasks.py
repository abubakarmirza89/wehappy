from celery import shared_task
from .communications import dispatch_email_batch
from .reminders import queue_due_reminders

@shared_task
def process_notifications():
    from .commercial_tasks import refresh_commercial_state
    refresh_commercial_state()
    queue_due_reminders()
    return dispatch_email_batch()
