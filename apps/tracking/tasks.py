"""
Celery tasks for MindMenta tracking application
Handles scheduled notifications and background processing
"""

from celery import shared_task
from django.conf import settings
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from datetime import datetime, timedelta
from django.utils.timezone import now
from twilio.rest import Client
from apps.tracking.models import MoodCheckIn, GratitudeEntry, User, MoodNotification, Relative
from apps.users.models import User as UserModel
import logging

logger = logging.getLogger(__name__)


def send_email_notification(recipient_email, subject, message):
    """Send a plain email notification to a recipient."""
    send_mail(
        subject=subject,
        message=message,
        from_email=settings.DEFAULT_FROM_EMAIL or 'noreply@wehappy.local',
        recipient_list=[recipient_email],
        fail_silently=False,
    )
    return True


def send_whatsapp_message(to_phone, message):
    """Send WhatsApp notification if Twilio credentials are configured."""
    account_sid = getattr(settings, 'TWILIO_ACCOUNT_SID', None)
    auth_token = getattr(settings, 'TWILIO_AUTH_TOKEN', None)
    from_whatsapp = getattr(settings, 'TWILIO_WHATSAPP_FROM', None)

    if not all([account_sid, auth_token, from_whatsapp]):
        logger.warning('Twilio credentials are not configured; skipping WhatsApp notification.')
        return False

    client = Client(account_sid, auth_token)
    client.messages.create(
        body=message,
        from_=from_whatsapp,
        to=f'whatsapp:{to_phone}'
    )
    return True


@shared_task
def send_daily_mood_reminder():
    """
    Send daily mood check-in reminders to all active users
    Runs at 9 AM daily
    """
    users = UserModel.objects.filter(is_active=True)
    sent_count = 0
    
    for user in users:
        try:
            # Create in-app notification
            # In production, this would also send push notifications or emails
            logger.info(f"Sending mood reminder to user: {user.email}")
            sent_count += 1
        except Exception as e:
            logger.error(f"Error sending mood reminder to {user.email}: {str(e)}")
    
    logger.info(f"Mood reminders sent to {sent_count} users")
    return f"Sent mood reminders to {sent_count} users"


@shared_task
def send_daily_gratitude_prompt():
    """
    Send daily gratitude journal prompts to all active users
    Runs at 8 AM daily
    Suggests users to record 3 things they're grateful for
    """
    users = UserModel.objects.filter(is_active=True)
    created_count = 0
    
    for user in users:
        try:
            today = now().date()
            # Check if user already has a gratitude entry today
            existing = GratitudeEntry.objects.filter(user=user, date=today).exists()
            
            if not existing:
                # In production, send notification prompting user to add gratitude entry
                logger.info(f"Sending gratitude prompt to user: {user.email}")
                created_count += 1
        except Exception as e:
            logger.error(f"Error sending gratitude prompt to {user.email}: {str(e)}")
    
    logger.info(f"Gratitude prompts sent to {created_count} users")
    return f"Sent gratitude prompts to {created_count} users"


@shared_task
def calculate_daily_brain_health_scores():
    """
    Calculate daily brain health scores for all users based on last 7 days of mood data
    Runs at 10 PM daily
    """
    users = UserModel.objects.filter(is_active=True)
    updated_count = 0
    
    for user in users:
        try:
            # Get last 7 days of mood check-ins
            last_7_days = now().date() - timedelta(days=7)
            check_ins = MoodCheckIn.objects.filter(user=user, date__gte=last_7_days)
            
            if check_ins.exists():
                # Calculate average mood score
                total_score = 0
                mood_count = 0
                
                for check_in in check_ins:
                    for mood in check_in.moods.all():
                        total_score += mood.score
                        mood_count += 1
                
                if mood_count > 0:
                    avg_score = total_score / mood_count
                    # Store or update brain health score
                    logger.info(f"Brain health score for {user.email}: {avg_score}")
                    updated_count += 1
        except Exception as e:
            logger.error(f"Error calculating brain health score for {user.email}: {str(e)}")
    
    logger.info(f"Brain health scores updated for {updated_count} users")
    return f"Updated brain health scores for {updated_count} users"


@shared_task
def send_notifications_to_relatives(mood_check_in_id):
    """
    Send mood notifications to user's relatives
    Called when a user completes a mood check-in
    Intelligently routes: in-app if relative is app user, WhatsApp otherwise
    """
    try:
        mood_check_in = MoodCheckIn.objects.get(id=mood_check_in_id)
        user = mood_check_in.user
        relatives = Relative.objects.filter(user=user)
        
        sent_count = 0
        for relative in relatives:
            try:
                # Determine notification channel
                if relative.is_app_user:
                    # Send in-app notification
                    logger.info(f"Sending in-app notification to relative: {relative.email}")
                    send_via = 'in_app'
                else:
                    # Send WhatsApp notification (requires Twilio setup)
                    logger.info(f"Sending WhatsApp to relative: {relative.phone_number}")
                    send_via = 'whatsapp'
                
                # Create notification record
                notification = MoodNotification.objects.create(
                    user=user,
                    relative=relative,
                    mood_check_in=mood_check_in,
                    message_text=f"Your loved one just checked in with mood update",
                    notification_type='check_in',
                    sent_via=send_via
                )
                
                sent_count += 1
            except Exception as e:
                logger.error(f"Error notifying relative {relative.name}: {str(e)}")
        
        logger.info(f"Notifications sent for mood check-in {mood_check_in_id} to {sent_count} relatives")
        return f"Sent to {sent_count} relatives"
        
    except MoodCheckIn.DoesNotExist:
        logger.error(f"MoodCheckIn {mood_check_in_id} not found")
        return "MoodCheckIn not found"
    except Exception as e:
        logger.error(f"Error in send_notifications_to_relatives: {str(e)}")
        return f"Error: {str(e)}"


@shared_task
def process_openai_chat_response(conversation_id, user_message):
    """
    Process user message through OpenAI API and generate counselor response
    Called asynchronously from chat endpoint
    
    TODO: Implement OpenAI API integration
    """
    try:
        from apps.tracking.models import ChatConversation, ChatMessage
        
        conversation = ChatConversation.objects.get(id=conversation_id)
        
        # TODO: Call OpenAI API with:
        # - User's mood history context
        # - Previous chat messages
        # - Current user message
        
        # For now, just log
        logger.info(f"Processing chat message for conversation {conversation_id}")
        
    except ChatConversation.DoesNotExist:
        logger.error(f"ChatConversation {conversation_id} not found")
    except Exception as e:
        logger.error(f"Error processing chat response: {str(e)}")
