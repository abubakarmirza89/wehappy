from django.core.management.base import BaseCommand
from apps.users.communications import dispatch_email_batch
from apps.users.reminders import queue_due_reminders

class Command(BaseCommand):
    help = 'Queue opted-in reminders and submit due Hearteli emails; run every minute.'
    def add_arguments(self, parser):
        parser.add_argument('--limit', type=int, default=100)
    def handle(self, *args, **options):
        queue_due_reminders()
        self.stdout.write(str(dispatch_email_batch(limit=max(1, min(options['limit'], 1000)))))
