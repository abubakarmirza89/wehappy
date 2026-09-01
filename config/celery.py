"""
Celery configuration for MindMenta
Handles scheduled tasks like daily mood reminders and gratitude prompts
"""

import os
from celery import Celery
from celery.schedules import crontab

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

app = Celery('mindmenta')

# Load configuration from Django settings
app.config_from_object('django.conf:settings', namespace='CELERY')

# Auto-discover tasks from all registered Django apps
app.autodiscover_tasks()


# Define periodic tasks
app.conf.beat_schedule = {
    'send-daily-mood-reminder': {
        'task': 'apps.tracking.tasks.send_daily_mood_reminder',
        'schedule': crontab(hour=9, minute=0),  # 9 AM daily
    },
    'send-daily-gratitude-prompt': {
        'task': 'apps.tracking.tasks.send_daily_gratitude_prompt',
        'schedule': crontab(hour=8, minute=0),  # 8 AM daily
    },
    'calculate-daily-brain-health': {
        'task': 'apps.tracking.tasks.calculate_daily_brain_health_scores',
        'schedule': crontab(hour=22, minute=0),  # 10 PM daily
    },
}

# Celery configuration
app.conf.update(
    # Task configuration
    task_serializer='json',
    accept_content=['json'],
    result_serializer='json',
    timezone='UTC',
    enable_utc=True,
    
    # Worker configuration
    worker_prefetch_multiplier=4,
    worker_max_tasks_per_child=1000,
)


@app.task(bind=True)
def debug_task(self):
    print(f'Request: {self.request!r}')
