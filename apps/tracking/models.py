from django.db import models
from django.conf import settings
from django.utils import timezone

User = settings.AUTH_USER_MODEL


class Relative(models.Model):
    user = models.ForeignKey(User, related_name="relatives", on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    email = models.EmailField()
    phone_number = models.CharField(max_length=20)
    is_app_user = models.BooleanField(default=False)
    relation = models.CharField(max_length=100, default='Friend')
    image = models.FileField(upload_to='relative_images/', null=True, blank=True, default='default_image.jpg')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class Mood(models.Model):
    name = models.CharField(max_length=100)
    img_emoji = models.FileField(upload_to="mood/emoji")
    score = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return self.name

    def calculate_brain_health(self):
        max_score = 100  # Maximum possible score
        if self.score is None or self.score <= 0:
            return 0
        elif self.score >= max_score:
            return 100
        else:
            return (self.score / max_score) * 100


class Suggestion(models.Model):
    mood = models.ForeignKey(Mood, related_name="suggestion", on_delete=models.CASCADE)
    suggestion_text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return self.suggestion_text


class Message(models.Model):
    mood = models.ForeignKey(Mood, on_delete=models.CASCADE)
    message_text = models.TextField()
    is_urgent = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = "Admin Message"
        verbose_name_plural = "Admin Messages"
        ordering = ["-created_at"]

    def __str__(self):
        return self.message_text


# ============ MOOD CHECK-IN SYSTEM ============
class MoodCheckIn(models.Model):
    """Daily mood check-in with multiple mood selections"""
    user = models.ForeignKey(User, related_name="mood_check_ins", on_delete=models.CASCADE)
    moods = models.ManyToManyField(Mood, related_name="check_ins")
    notes = models.TextField(null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    date = models.DateField(default=timezone.now)
    
    class Meta:
        ordering = ["-timestamp"]
        verbose_name = "Mood Check-In"
        verbose_name_plural = "Mood Check-Ins"
    
    def __str__(self):
        return f"{self.user.name} - {self.date}"


# ============ CHAT SYSTEM ============
class ChatConversation(models.Model):
    """Chatbot conversation with AI counselor"""
    user = models.ForeignKey(User, related_name="chat_conversations", on_delete=models.CASCADE)
    mood_check_in = models.ForeignKey(MoodCheckIn, null=True, blank=True, on_delete=models.SET_NULL, related_name="chats")
    started_at = models.DateTimeField(auto_now_add=True)
    ended_at = models.DateTimeField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    summary = models.TextField(null=True, blank=True)  # AI summary of conversation
    
    class Meta:
        ordering = ["-started_at"]
    
    def __str__(self):
        return f"Chat with {self.user.name} - {self.started_at}"


class ChatMessage(models.Model):
    """Individual messages in a chat conversation"""
    SENDER_CHOICES = [
        ('user', 'User'),
        ('bot', 'AI Counselor'),
    ]
    
    conversation = models.ForeignKey(ChatConversation, related_name="messages", on_delete=models.CASCADE)
    sender = models.CharField(max_length=10, choices=SENDER_CHOICES)
    message_text = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ["timestamp"]
    
    def __str__(self):
        return f"{self.sender}: {self.message_text[:50]}"


# ============ NOTIFICATIONS SYSTEM ============
class MoodNotification(models.Model):
    """Notifications sent to relatives based on user's mood"""
    user = models.ForeignKey(User, related_name="mood_notifications_sent", on_delete=models.CASCADE)
    relative = models.ForeignKey(Relative, related_name="notifications_received", on_delete=models.CASCADE)
    mood_check_in = models.ForeignKey(MoodCheckIn, null=True, blank=True, on_delete=models.SET_NULL)
    message_text = models.TextField()
    notification_type = models.CharField(max_length=20, choices=[
        ('happy', 'Happy - Celebration'),
        ('sad', 'Sad - Support Needed'),
        ('angry', 'Angry - Calming Support'),
        ('stressed', 'Stressed - Assistance Needed'),
        ('neutral', 'Neutral - Check-in'),
    ], default='neutral')
    is_sent = models.BooleanField(default=False)
    sent_via = models.CharField(max_length=20, choices=[
        ('in_app', 'In-App'),
        ('whatsapp', 'WhatsApp'),
        ('email', 'Email'),
        ('sms', 'SMS'),
    ], default='in_app')
    sent_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ["-created_at"]
    
    def __str__(self):
        return f"Notification to {self.relative.name} - {self.notification_type}"


class NotificationTemplate(models.Model):
    """Templates for different mood notifications"""
    mood = models.ForeignKey(Mood, related_name="notification_templates", on_delete=models.CASCADE)
    notification_type = models.CharField(max_length=20, choices=[
        ('happy', 'Happy'),
        ('sad', 'Sad'),
        ('angry', 'Angry'),
        ('stressed', 'Stressed'),
        ('neutral', 'Neutral'),
    ])
    template_text = models.TextField()  # e.g., "{{name}} is feeling {{mood}} today. {{suggestion}}"
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ['mood', 'notification_type']
    
    def __str__(self):
        return f"{self.mood.name} - {self.notification_type}"


# ============ GRATITUDE SYSTEM ============
class GratitudeEntry(models.Model):
    """Daily gratitude entries - 3 things user is grateful for"""
    user = models.ForeignKey(User, related_name="gratitude_entries", on_delete=models.CASCADE)
    gratitude_1 = models.TextField()
    gratitude_2 = models.TextField()
    gratitude_3 = models.TextField()
    date = models.DateField(default=timezone.now)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ["-date"]
        verbose_name = "Gratitude Entry"
        verbose_name_plural = "Gratitude Entries"
        unique_together = ['user', 'date']
    
    def __str__(self):
        return f"{self.user.name} - {self.date}"