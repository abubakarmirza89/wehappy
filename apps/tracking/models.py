import uuid

from django.db import models
from django.conf import settings
from django.utils import timezone
from django.utils.text import slugify

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


class Workspace(models.Model):
    """
    A private workspace for a team, family, or partner circle.
    Supports QR invite flow, approval gates, managerial visibility,
    and consent-based emotional sharing.
    """
    WORKSPACE_TYPE_FAMILY = "family"
    WORKSPACE_TYPE_COUPLE = "couple"
    WORKSPACE_TYPE_OFFICE = "office"

    WORKSPACE_TYPE_CHOICES = [
        (WORKSPACE_TYPE_FAMILY, "Family"),
        (WORKSPACE_TYPE_COUPLE, "Couple"),
        (WORKSPACE_TYPE_OFFICE, "Office"),
    ]

    SUBSCRIPTION_PLAN_PERSONAL = "personal"
    SUBSCRIPTION_PLAN_OFFICE_20 = "office_20"

    SUBSCRIPTION_PLAN_CHOICES = [
        (SUBSCRIPTION_PLAN_PERSONAL, "Personal"),
        (SUBSCRIPTION_PLAN_OFFICE_20, "Office $20/month"),
    ]

    owner = models.ForeignKey(User, related_name="owned_workspaces", on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True, null=True)
    workspace_type = models.CharField(max_length=20, choices=WORKSPACE_TYPE_CHOICES, default=WORKSPACE_TYPE_FAMILY)
    subscription_plan = models.CharField(max_length=20, choices=SUBSCRIPTION_PLAN_CHOICES, default=SUBSCRIPTION_PLAN_PERSONAL)
    slug = models.SlugField(max_length=120, unique=True, blank=True)
    invite_code = models.CharField(max_length=50, unique=True, blank=True, db_index=True)
    qr_code_data = models.CharField(max_length=255, blank=True, null=True)
    is_approval_required = models.BooleanField(default=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        if not self.invite_code:
            self.invite_code = uuid.uuid4().hex[:12].upper()
        super().save(*args, **kwargs)

    def __str__(self):
        return self.name

    @property
    def join_url(self):
        return f"/api/tracking/workspaces/join/?invite={self.invite_code}"


class WorkspaceMembership(models.Model):
    """
    Membership state for each user inside a workspace.
    Supports owner/manager/employee hierarchy with explicit consent
    for sharing mood-based support messages.
    """
    ROLE_OWNER = "owner"
    ROLE_MANAGER = "manager"
    ROLE_EMPLOYEE = "employee"

    ROLE_CHOICES = [
        (ROLE_OWNER, "Owner"),
        (ROLE_MANAGER, "Manager"),
        (ROLE_EMPLOYEE, "Employee"),
    ]

    STATUS_PENDING = "pending"
    STATUS_APPROVED = "approved"
    STATUS_REJECTED = "rejected"

    STATUS_CHOICES = [
        (STATUS_PENDING, "Pending"),
        (STATUS_APPROVED, "Approved"),
        (STATUS_REJECTED, "Rejected"),
    ]

    workspace = models.ForeignKey(Workspace, related_name="memberships", on_delete=models.CASCADE)
    user = models.ForeignKey(User, related_name="workspace_memberships", on_delete=models.CASCADE)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default=ROLE_EMPLOYEE)
    designation = models.CharField(max_length=100, blank=True, default="")
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default=STATUS_PENDING)
    invited_by = models.ForeignKey(User, related_name="workspace_invites_sent", on_delete=models.SET_NULL, null=True, blank=True)
    can_share_mood_with_manager = models.BooleanField(default=False)
    can_receive_support_notifications = models.BooleanField(default=True)
    joined_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("workspace", "user")
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.user.name} in {self.workspace.name} ({self.role})"


class WorkspaceSupportRequest(models.Model):
    """Support suggestion request generated from a partner's mood state."""
    workspace = models.ForeignKey(Workspace, related_name="support_requests", on_delete=models.CASCADE)
    sender = models.ForeignKey(User, related_name="sent_support_requests", on_delete=models.CASCADE)
    receiver = models.ForeignKey(User, related_name="received_support_requests", on_delete=models.CASCADE)
    message = models.TextField()
    is_accepted = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"Support request: {self.sender.name} -> {self.receiver.name}"


class WorkspaceResource(models.Model):
    workspace = models.ForeignKey(Workspace, related_name='resources', on_delete=models.CASCADE)
    title = models.CharField(max_length=120)
    description = models.CharField(max_length=250, blank=True)
    url = models.URLField(max_length=500)
    created_at = models.DateTimeField(auto_now_add=True)


class WorkspaceRoleAudit(models.Model):
    workspace = models.ForeignKey(Workspace, related_name='role_events', on_delete=models.CASCADE)
    actor = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='+')
    member = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='+')
    from_role = models.CharField(max_length=20)
    to_role = models.CharField(max_length=20)
    created_at = models.DateTimeField(auto_now_add=True)


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
    feeling_category = models.CharField(max_length=20, choices=[
        ('great', 'Great'), ('good', 'Good'), ('okay', 'Okay'),
        ('not_great', 'Not great'), ('struggling', 'Struggling')], blank=True)
    moods = models.ManyToManyField(Mood, related_name="check_ins")
    notes = models.TextField(null=True, blank=True)
    context_tags = models.JSONField(default=list, blank=True)
    support_preferences = models.JSONField(default=list, blank=True)
    workspace = models.ForeignKey('Workspace', null=True, blank=True, on_delete=models.SET_NULL, related_name='hearteli_check_ins')
    timestamp = models.DateTimeField(auto_now_add=True)
    date = models.DateField(default=timezone.localdate)
    
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
    therapist = models.ForeignKey(User, related_name="therapist_conversations", null=True, blank=True, on_delete=models.SET_NULL)
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
        ('therapist', 'Therapist'),
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
    date = models.DateField(default=timezone.localdate)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ["-date"]
        verbose_name = "Gratitude Entry"
        verbose_name_plural = "Gratitude Entries"
        unique_together = ['user', 'date']
    
    def __str__(self):
        return f"{self.user.name} - {self.date}"
# Hearteli: disclosure is opt-in and scoped to one recipient and one check-in.
class CircleConnection(models.Model):
    owner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='hearteli_circle')
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='hearteli_connections')
    relationship = models.CharField(max_length=40, default='Friend')
    accepted_at = models.DateTimeField(null=True, blank=True)
    may_receive_nudges = models.BooleanField(default=False)
    may_receive_preference = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [models.UniqueConstraint(fields=['owner', 'recipient'], name='hearteli_unique_circle')]


class EmpathyNudge(models.Model):
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='hearteli_nudges_sent')
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='hearteli_nudges_received')
    check_in = models.ForeignKey(MoodCheckIn, on_delete=models.CASCADE, related_name='hearteli_nudges')
    message = models.CharField(max_length=500)
    support_preference = models.CharField(max_length=120, blank=True)
    # Historical nudges predate retry keys; all new API writes require one.
    idempotency_key = models.UUIDField(null=True, blank=True)
    delivery_status = models.CharField(max_length=20, choices=[('created', 'Created'), ('queued', 'Queued'), ('sent', 'Sent'), ('failed', 'Failed'), ('delivered', 'Delivered'), ('opened', 'Opened')], default='created')
    status = models.CharField(max_length=20, choices=[('sent','Sent'),('acknowledged','Acknowledged'),('cannot_help','Cannot help')], default='sent')
    created_at = models.DateTimeField(auto_now_add=True)
    responded_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        constraints = [models.UniqueConstraint(fields=['sender', 'idempotency_key'], name='hearteli_unique_nudge_retry')]


class SupportOutcome(models.Model):
    member = models.ForeignKey(User, on_delete=models.CASCADE, related_name='hearteli_outcomes')
    nudge = models.OneToOneField(EmpathyNudge, on_delete=models.CASCADE, related_name='outcome')
    result = models.CharField(max_length=20, choices=[('yes', 'Yes'), ('a_little', 'A little'), ('not_yet', 'Not yet'), ('prefer_not', 'Prefer not to say')])
    private_note = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)


class ConsentEvent(models.Model):
    actor = models.ForeignKey(User, on_delete=models.CASCADE, related_name='hearteli_consent_events')
    connection = models.ForeignKey(CircleConnection, null=True, on_delete=models.SET_NULL)
    event = models.CharField(max_length=40)
    categories = models.JSONField(default=list)
    occurred_at = models.DateTimeField(auto_now_add=True)


class HearteliPreferences(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='hearteli_preferences')
    use_contexts = models.JSONField(default=list, blank=True)
    reminder_enabled = models.BooleanField(default=False)
    nudge_notifications = models.BooleanField(default=True)
    quiet_start = models.TimeField(null=True, blank=True)
    quiet_end = models.TimeField(null=True, blank=True)
    rich_lock_preview = models.BooleanField(default=False)


class TherapistContextGrant(models.Model):
    member = models.ForeignKey(User, on_delete=models.CASCADE, related_name='hearteli_therapy_grants')
    therapist = models.ForeignKey(User, on_delete=models.CASCADE, related_name='hearteli_context_received')
    check_ins = models.ManyToManyField(MoodCheckIn, related_name='hearteli_therapy_grants')
    include_notes = models.BooleanField(default=False)
    expires_at = models.DateTimeField()
    revoked_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
