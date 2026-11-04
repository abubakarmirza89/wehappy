import uuid
from decimal import Decimal
from .private_storage import CredentialStorage,SponsorCreativeStorage
from django.db import models
from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.utils import timezone
from django.utils.translation import gettext_lazy as _
from rest_framework.authtoken.models import Token

from apps.users.managers import UserManager


class User(AbstractUser):
    name = models.CharField(_("Name of User"), max_length=255, unique=True)
    email = models.EmailField(_("email address"), unique=True)
    phone_number = models.CharField(max_length=20)
    profile_picture = models.FileField(upload_to="user_profiles/", null=True, blank=True)
    date_of_birth = models.DateField(null=True, blank=True)
    is_therapist = models.BooleanField(default=False)
    first_name = None  # type: ignore
    last_name = None  # type: ignore
    username = None  # type: ignore

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["name"]

    objects = UserManager()

    def brain_health_score(self):
        ratings = self.brain_score.all()
        if ratings:
            return round(sum(r.rating for r in ratings) / len(ratings), 2)
        else:
            return 0

    def star(self):
        ratings = self.feedback_therapist.all()
        if ratings:
            return round(sum(r.rating for r in ratings) / len(ratings), 2)
        else:
            return 0
    

class Therapist(models.Model):
    practitioner_type=models.CharField(max_length=100,default='Therapist')
    registration_number=models.CharField(max_length=120,blank=True)
    public_reviews_permitted=models.BooleanField(default=False)
    review_policy_reference=models.CharField(max_length=250,blank=True)
    registration_body=models.CharField(max_length=160,blank=True)
    specialties=models.CharField(max_length=250,blank=True)
    verification_status=models.CharField(max_length=20,default='pending',choices=[(v,v.title()) for v in ['pending','verified','rejected','expired','suspended']])
    verified_at=models.DateTimeField(null=True,blank=True)
    verification_expires_at=models.DateTimeField(null=True,blank=True)
    verified_by=models.ForeignKey('User',on_delete=models.SET_NULL,null=True,blank=True,related_name='+')
    verification_evidence=models.FileField(upload_to='evidence/',storage=CredentialStorage(),blank=True)
    availability_status=models.CharField(max_length=24,default='active',choices=[('active','Accepting clients'),('not_accepting','Not accepting new clients'),('temporary','Temporarily unavailable')])
    last_availability_update=models.DateTimeField(default=timezone.now)
    last_activity_confirmation=models.DateTimeField(default=timezone.now)
    referral_code=models.UUIDField(default=uuid.uuid4,unique=True,editable=False)
    def clean(self):
        from django.core.exceptions import ValidationError
        if self.verification_status=='verified' and (not self.verification_expires_at or self.verification_expires_at<=timezone.now()):
            raise ValidationError({'verification_expires_at':'A future credential expiry is required.'})
        if self.public_reviews_permitted and not self.review_policy_reference:
            raise ValidationError({'review_policy_reference':'Record the approved professional advertising policy.'})

    @property
    def verified(self):
        return self.verification_status=='verified' and self.verification_expires_at is not None and self.verification_expires_at>timezone.now()
    @property
    def activity_status(self):return 'inactive' if (timezone.now()-self.last_activity_confirmation).days>=MarketplacePolicy.current().inactive_days else self.availability_status
    @property
    def searchable(self):
        return self.user.is_active and self.user.is_therapist and self.verified and self.is_available and self.availability_status=='active' and (timezone.now()-self.last_activity_confirmation).days<MarketplacePolicy.current().inactive_days

    user = models.OneToOneField(User, related_name="therapist_profile", on_delete=models.CASCADE)
    degrees = models.TextField(null=True, blank=True)
    certifications = models.TextField(null=True, blank=True)
    card_id = models.CharField(max_length=25, blank=True, default='')
    hourly_rate = models.DecimalField(max_digits=6, decimal_places=2, null=True, blank=True)
    is_available = models.BooleanField(default=False)
    is_active = models.BooleanField(default=False)

    def __str__(self):
        return self.user.email


@receiver(post_save, sender=User)
def create_therapist_profile(sender, instance, created, **kwargs):
    if created and instance.is_therapist:
        Therapist.objects.create(user=instance)


class Appointment(models.Model):
    booking_credential_verified=models.BooleanField(default=False)
    duration_minutes=models.PositiveIntegerField(default=60)
    acquisition_source=models.CharField(max_length=10,default='platform',choices=[('platform','Platform acquired'),('referral','Therapist referred')])
    commission_percent=models.DecimalField(max_digits=5,decimal_places=2,default=15)

    user = models.ForeignKey(User, related_name="appointments", on_delete=models.CASCADE)
    therapist = models.ForeignKey(User, related_name="appointment_User", on_delete=models.CASCADE)
    date = models.DateField()
    time = models.TimeField()
    location = models.CharField(max_length=200)
    reason = models.CharField(max_length=200)
    fee = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    commission = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    therapist_earnings = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    payment_status = models.CharField(max_length=20, choices=(('pending', 'Pending'), ('paid', 'Paid'), ('refunded', 'Refunded')), default='pending')
    payment_checkout_session_id = models.CharField(max_length=200, blank=True, default='')
    payment_intent_id = models.CharField(max_length=255, blank=True, default='')
    charge_id = models.CharField(max_length=255, blank=True, default='')
    refund_id = models.CharField(max_length=255, blank=True, default='')
    status = models.CharField(
        max_length=20,
        choices=(
            ("BOOKED", "Booked"),
            ("IN_PROGRESS", "In Progress"),
            ("COMPLETED", "Completed"),
            ("CANCELED", "Canceled"),
        ),
        default="BOOKED",
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.user.name} - {self.therapist.name}"


@receiver(post_save, sender=Appointment)
def create_notification(sender, instance, created, **kwargs):
    if created:
        Notification.objects.create(
            recipient=instance.therapist,
            verb=f"You have a new appointment with {instance.user.name}",
            created_at=timezone.now(),
        )


@receiver(post_save, sender=Appointment)
def create_user_history(sender, instance, created, **kwargs):
    if created and instance.status == "BOOKED":
        UserHistory.objects.create(user=instance.user, therapist=instance.therapist, appointment=instance)


class Notification(models.Model):
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name="notifications")
    verb = models.CharField(max_length=255)
    read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.recipient.name} - {self.verb}"


class DeviceToken(models.Model):
    """A Firebase Cloud Messaging token registered by a user's device."""
    user = models.ForeignKey(User, related_name="device_tokens", on_delete=models.CASCADE)
    token = models.CharField(max_length=512, unique=True)
    platform = models.CharField(max_length=20, blank=True, default="unknown")
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["-updated_at"]

    def __str__(self):
        return f"{self.user.name} - {self.platform}"


class Feedback(models.Model):
    submitted_at=models.DateTimeField(default=timezone.now)
    moderation_status=models.CharField(max_length=20,default='pending',choices=[('pending','Pending'),('approved','Approved'),('removed','Removed'),('reported','Reported')])
    public_visibility=models.BooleanField(default=False)
    moderation_note=models.TextField(blank=True)

    user = models.ForeignKey(User, related_name="feedbacks", on_delete=models.CASCADE)
    therapist = models.ForeignKey(User, related_name="feedback_therapist", on_delete=models.CASCADE)
    appointment = models.OneToOneField(Appointment, related_name="review", on_delete=models.CASCADE)
    rating = models.PositiveIntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    comment = models.TextField()

    def __str__(self):
        return f"{self.user.name} - {self.user.email}"


class WithdrawalRequest(models.Model):
    STATUS_CHOICES = (('pending', 'Pending'), ('approved', 'Approved'), ('rejected', 'Rejected'), ('paid', 'Paid'))

    therapist = models.ForeignKey(User, related_name='withdrawal_requests', on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    payout_account = models.CharField(max_length=255)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    admin_note = models.TextField(blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)
    processed_at = models.DateTimeField(null=True, blank=True)
    payout_reference = models.CharField(max_length=200, blank=True)
    processed_by = models.ForeignKey(User,on_delete=models.SET_NULL,null=True,blank=True,related_name='processed_withdrawals')

    class Meta:
        ordering = ['-created_at']


class UserHistory(models.Model):
    user = models.ForeignKey(User, related_name="user_history", on_delete=models.CASCADE)
    therapist = models.ForeignKey(User, on_delete=models.CASCADE, related_name="therapist_history")
    appointment = models.OneToOneField(Appointment, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.user.name} - {self.therapist.name}"


class Brain_Health_Score(models.Model):
    user = models.ForeignKey(User, related_name="brain_score", on_delete=models.CASCADE)
    rating = models.IntegerField(validators=[MinValueValidator(1), MaxValueValidator(100)])
    created_at = models.DateTimeField(default=timezone.now, editable=False)

    def __str__(self):
        return f"{self.user.name} - {self.rating} - {self.created_at}"


class Send_To_Relative(models.Model):
    message_text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = "Send To Relative"
        verbose_name_plural = "Send To Relatives"
        ordering = ["-created_at"]

    def __str__(self):
        return self.message_text


class Suggestion_Therapist(models.Model):
    message_text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = "Suggestion Therapist"
        verbose_name_plural = "Suggestion Therapists"
        ordering = ["-created_at"]

    def __str__(self):
        return self.message_text

class EmailDelivery(models.Model):
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='email_deliveries')
    event_key = models.CharField(max_length=180, unique=True)
    kind = models.CharField(max_length=40)
    channel = models.CharField(max_length=10, default='email', choices=[('email', 'Email'), ('push', 'Push')])
    subject = models.CharField(max_length=200)
    message = models.TextField()
    path = models.TextField(blank=True)
    target_id = models.PositiveBigIntegerField(null=True, blank=True)
    sensitive = models.BooleanField(default=False)
    status = models.CharField(max_length=20, default='pending', choices=[
        ('pending', 'Pending'), ('retry', 'Retry'), ('sent', 'SMTP accepted'),
        ('failed', 'Failed'), ('suppressed', 'Suppressed')])
    attempts = models.PositiveSmallIntegerField(default=0)
    error_code = models.CharField(max_length=80, blank=True)
    next_attempt_at = models.DateTimeField(default=timezone.now)
    created_at = models.DateTimeField(auto_now_add=True)
    sent_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        indexes = [models.Index(fields=['status', 'next_attempt_at'], name='hearteli_email_due')]


class TherapistApplication(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='therapy_application')
    bio = models.TextField()
    credentials = models.TextField()
    license_number = models.CharField(max_length=120)
    location = models.CharField(max_length=120)
    modalities = models.CharField(max_length=120, default='Online')
    status = models.CharField(max_length=16, default='pending', choices=[('pending','Pending review'),('approved','Approved'),('rejected','Rejected')])
    review_note = models.TextField(blank=True)
    updated_at = models.DateTimeField(auto_now=True)


class TherapyLedger(models.Model):
    therapist = models.ForeignKey(User, on_delete=models.PROTECT, related_name='therapy_ledger')
    appointment = models.ForeignKey(Appointment, on_delete=models.PROTECT)
    event_key = models.CharField(max_length=200, unique=True)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    kind = models.CharField(max_length=20, choices=[('earning','Earning'),('refund','Refund')])
    created_at = models.DateTimeField(auto_now_add=True)


class AppointmentMessage(models.Model):
    appointment = models.ForeignKey(Appointment, on_delete=models.CASCADE, related_name='messages')
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    body = models.CharField(max_length=2000)
    created_at = models.DateTimeField(auto_now_add=True)
    class Meta:
        ordering = ['created_at', 'id']


class BillingPlan(models.Model):
    name = models.CharField(max_length=100)
    stripe_price_id = models.CharField(max_length=120, unique=True,null=True,blank=True)
    monthly_price = models.DecimalField(max_digits=10, decimal_places=2)
    currency = models.CharField(max_length=3, default='usd')
    member_limit = models.PositiveIntegerField(default=20)
    active = models.BooleanField(default=True)
    def __str__(self):
        return self.name


class BusinessSubscription(models.Model):
    organisation_status=models.CharField(max_length=12,default='active',choices=[('draft','Draft'),('active','Active'),('paused','Paused'),('expired','Expired')])
    legal_name=models.CharField(max_length=200,blank=True)
    contact_email=models.EmailField(blank=True)
    feature_flags=models.JSONField(default=list,blank=True)
    notes=models.TextField(blank=True)
    billing_status=models.CharField(max_length=12,default='unpaid',choices=[('unpaid','Unpaid'),('paid','Paid'),('waived','Waived'),('overdue','Overdue')])
    starts_at=models.DateTimeField(default=timezone.now)
    manual_status=models.CharField(max_length=16,default='suspended',choices=[('active','Active'),('expired','Expired'),('suspended','Suspended')])
    invoice_reference=models.CharField(max_length=160,blank=True)
    agreed_amount=models.DecimalField(max_digits=12,decimal_places=2,null=True,blank=True)
    currency=models.CharField(max_length=3,default='AUD')
    tax_treatment=models.CharField(max_length=200,blank=True)
    paid_at=models.DateTimeField(null=True,blank=True)
    contract_reference=models.CharField(max_length=160,blank=True)
    organisation_type=models.CharField(max_length=20,default='employer',choices=[('employer','Employer'),('practitioner','Practitioner organisation')])

    workspace = models.OneToOneField('tracking.Workspace', on_delete=models.CASCADE, related_name='billing')
    plan = models.ForeignKey(BillingPlan, on_delete=models.PROTECT)
    checkout_session_id = models.CharField(max_length=200, blank=True)
    customer_id = models.CharField(max_length=120, blank=True)
    stripe_subscription_id = models.CharField(max_length=120, unique=True, null=True, blank=True)
    status = models.CharField(max_length=32, default='incomplete')
    period_end = models.DateTimeField(null=True, blank=True)
    cancel_at_period_end = models.BooleanField(default=False)
    @property
    def effective_status(self):
        if self.period_end and self.period_end<=timezone.now():return 'expired'
        return 'active' if self.entitled else 'suspended'
    @property
    def entitled(self):
        return self.workspace.is_active and self.organisation_status=='active' and self.manual_status=='active' and self.starts_at<=timezone.now() and self.period_end is not None and self.period_end>timezone.now()


class PaymentEvent(models.Model):
    event_id = models.CharField(max_length=200, unique=True)
    processed_at = models.DateTimeField(auto_now_add=True)


class MarketplacePolicy(models.Model):
    nudge_sponsors_enabled=models.BooleanField(default=False)
    nudge_ad_policy_reference=models.CharField(max_length=250,blank=True)
    platform_commission = models.DecimalField(max_digits=5,decimal_places=2,default=15,validators=[MinValueValidator(0),MaxValueValidator(100)])
    referral_commission = models.DecimalField(max_digits=5,decimal_places=2,default=5,validators=[MinValueValidator(0),MaxValueValidator(100)])
    reminder_days = models.PositiveIntegerField(default=30,validators=[MinValueValidator(1)])
    inactive_days = models.PositiveIntegerField(default=45,validators=[MinValueValidator(2)])
    subscription_reminder_days = models.PositiveIntegerField(default=7)
    public_reviews_enabled = models.BooleanField(default=False)
    reviews_policy_reference = models.CharField(max_length=250,blank=True)
    @classmethod
    def current(cls): return cls.objects.get_or_create(pk=1)[0]
    def clean(self):
        from django.core.exceptions import ValidationError
        if self.nudge_sponsors_enabled and not self.nudge_ad_policy_reference: raise ValidationError('Record the approved placement policy before enabling sponsored nudges.')
        if self.inactive_days<=self.reminder_days: raise ValidationError('Inactivity threshold must exceed the reminder interval.')
        if self.public_reviews_enabled and not self.reviews_policy_reference: raise ValidationError('Record the applicable approved advertising/review policy before enabling public reviews.')


class SessionOffering(models.Model):
    therapist=models.ForeignKey(Therapist,on_delete=models.CASCADE,related_name='session_offerings')
    duration_minutes=models.PositiveIntegerField(validators=[MinValueValidator(10),MaxValueValidator(240)])
    fee=models.DecimalField(max_digits=10,decimal_places=2,validators=[MinValueValidator(Decimal('0.01'))])
    def __str__(self):return f'{self.duration_minutes} minutes — USD {self.fee}'
    approved=models.BooleanField(default=False)
    active=models.BooleanField(default=True)
    reviewed_by=models.ForeignKey(User,on_delete=models.SET_NULL,null=True,blank=True,related_name='+')


class CommercialAudit(models.Model):
    actor=models.ForeignKey(User,on_delete=models.SET_NULL,null=True,related_name='+')
    object_type=models.CharField(max_length=80)
    object_id=models.CharField(max_length=80)
    action=models.CharField(max_length=100)
    created_at=models.DateTimeField(auto_now_add=True)


class OrganisationInvitation(models.Model):
    workspace=models.ForeignKey('tracking.Workspace',on_delete=models.CASCADE,related_name='commercial_invitations')
    token_hash=models.CharField(max_length=64,unique=True)
    expires_at=models.DateTimeField()
    max_redemptions=models.PositiveIntegerField(default=20)
    revoked_at=models.DateTimeField(null=True,blank=True)
    created_by=models.ForeignKey(User,on_delete=models.SET_NULL,null=True,related_name='+')
    created_at=models.DateTimeField(auto_now_add=True)


class InvitationRedemption(models.Model):
    invitation=models.ForeignKey(OrganisationInvitation,on_delete=models.CASCADE,related_name='redemptions')
    user=models.ForeignKey(User,on_delete=models.CASCADE)
    created_at=models.DateTimeField(auto_now_add=True)
    class Meta:
        constraints=[models.UniqueConstraint(fields=['invitation','user'],name='unique_commercial_redemption')]


class SponsorCampaign(models.Model):
    sponsor_name=models.CharField(max_length=150)
    contact_email=models.EmailField(blank=True)
    name=models.CharField(max_length=160)
    placement=models.CharField(max_length=20,choices=[('nudge','Empathy Nudge acknowledgement'),('search','Therapist search')])
    therapist=models.ForeignKey(Therapist,on_delete=models.CASCADE,null=True,blank=True,related_name='sponsor_campaigns')
    benefit_subscription=models.ForeignKey(BusinessSubscription,on_delete=models.PROTECT,null=True,blank=True)
    creative=models.ImageField(upload_to='approved_sponsors/',storage=SponsorCreativeStorage(),blank=True)
    destination=models.URLField(blank=True)
    starts_at=models.DateTimeField()
    ends_at=models.DateTimeField()
    status=models.CharField(max_length=20,default='draft',choices=[(s,s.replace('_',' ').title()) for s in ['draft','pending_review','approved','active','paused','completed','rejected']])
    priority=models.PositiveIntegerField(default=0)
    impression_cap=models.PositiveIntegerField(default=10000)
    per_recipient_cap=models.PositiveIntegerField(default=1)
    payment_reference=models.CharField(max_length=150,blank=True)
    approved_by=models.ForeignKey(User,on_delete=models.SET_NULL,null=True,blank=True,related_name='+')
    def clean(self):
        from django.core.exceptions import ValidationError
        from urllib.parse import urlsplit
        import ipaddress
        if self.ends_at and self.starts_at and self.ends_at<=self.starts_at: raise ValidationError('Campaign end must be after start.')
        if self.placement=='search' and not self.therapist_id: raise ValidationError('Choose a therapist for sponsored search.')
        if self.destination:
            u=urlsplit(self.destination)
            if u.scheme!='https' or not u.hostname or u.username or u.password or u.hostname.lower() in ('localhost','localhost.localdomain'): raise ValidationError('Use an approved public HTTPS destination.')
            try:
                if not ipaddress.ip_address(u.hostname).is_global: raise ValidationError('Private destinations are prohibited.')
            except ValueError: pass
        if self.status in ('approved','active') and not self.approved_by_id: raise ValidationError('An administrator must approve this campaign.')


class SponsorEventTicket(models.Model):
    import uuid
    id=models.UUIDField(primary_key=True,default=uuid.uuid4,editable=False)
    campaign=models.ForeignKey(SponsorCampaign,on_delete=models.CASCADE,related_name='tickets')
    viewer_hash=models.CharField(max_length=64)
    placement=models.CharField(max_length=20)
    context_id=models.PositiveBigIntegerField(null=True,blank=True)
    expires_at=models.DateTimeField()
    booking_started_at=models.DateTimeField(null=True,blank=True)
    shown_at=models.DateTimeField(null=True,blank=True)
    clicked_at=models.DateTimeField(null=True,blank=True)


class ReviewReport(models.Model):
    review=models.ForeignKey(Feedback,on_delete=models.CASCADE,related_name='reports')
    reporter=models.ForeignKey(User,on_delete=models.CASCADE)
    reason=models.CharField(max_length=500)
    created_at=models.DateTimeField(default=timezone.now)
    class Meta:
        constraints=[models.UniqueConstraint(fields=['review','reporter'],name='unique_review_report')]


class SponsorBookingAttribution(models.Model):
    appointment=models.OneToOneField(Appointment,on_delete=models.CASCADE,related_name='sponsor_attribution')
    ticket=models.ForeignKey(SponsorEventTicket,on_delete=models.CASCADE,related_name='bookings')
    created_at=models.DateTimeField(default=timezone.now)
