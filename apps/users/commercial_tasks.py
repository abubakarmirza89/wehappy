from django.utils import timezone
from django.conf import settings
from django.db.models import Q
from .models import SponsorEventTicket,Therapist,MarketplacePolicy,BusinessSubscription,CommercialAudit,User,Appointment,SponsorCampaign
from .communications import queue_email


def refresh_commercial_state(at=None):
    now=at or timezone.now();p=MarketplacePolicy.current()
    for sub in BusinessSubscription.objects.filter(manual_status='active',period_end__lte=now):
        sub.manual_status='expired';sub.organisation_status='expired';sub.save(update_fields=['manual_status','organisation_status'])
        CommercialAudit.objects.create(object_type='BusinessSubscription',object_id=str(sub.pk),action='automatic_expiry')
    for sub in BusinessSubscription.objects.filter(manual_status='active',period_end__gt=now,period_end__lte=now+timezone.timedelta(days=p.subscription_reminder_days)).select_related('workspace__owner'):
        queue_email(sub.workspace.owner,'subscription_expiry','Your Hearteli organisation access is due to expire','Contact your Hearteli administrator to renew. Your personal account, check-ins and Circle remain available.',key=f'expiry:{sub.pk}:{sub.period_end.isoformat()}',path=f'/work/{sub.workspace_id}/billing/')
    for therapist in Therapist.objects.filter(user__is_active=True,user__is_therapist=True).select_related('user'):
        age=(now-therapist.last_activity_confirmation).days
        if age>=p.reminder_days:
            queue_email(therapist.user,'activity_confirmation','Are you still accepting clients? · Hearteli','Please confirm your availability in your practice profile. Existing appointments remain available.',key=f'activity:{therapist.pk}:{therapist.last_activity_confirmation.isoformat()}',path='/practice/profile/')
        if age>=p.inactive_days and Appointment.objects.filter(therapist=therapist.user,date__gte=now.date(),status__in=['BOOKED','IN_PROGRESS']).exists():
            for staff in User.objects.filter(is_active=True,is_staff=True):
                queue_email(staff,'inactive_provider','Hearteli practitioner activity needs review','A practitioner with upcoming appointments has not confirmed availability. Review their profile in admin.',key=f'inactive:{therapist.pk}:{staff.pk}:{therapist.last_activity_confirmation.isoformat()}',path='/'+settings.ADMIN_URL)
    for therapist in Therapist.objects.filter(verification_status='verified',verification_expires_at__lte=now):
        therapist.verification_status='expired';therapist.save(update_fields=['verification_status'])
        CommercialAudit.objects.create(object_type='Therapist',object_id=str(therapist.pk),action='credential_expiry')
    for campaign in SponsorCampaign.objects.filter(status__in=['approved','active'],ends_at__lte=now):
        campaign.status='completed';campaign.save(update_fields=['status'])
        CommercialAudit.objects.create(object_type='SponsorCampaign',object_id=str(campaign.pk),action='automatic_expiry')

    # Remove recipient pseudonyms after the campaign ends plus the retention window.
    SponsorEventTicket.objects.filter(campaign__ends_at__lt=now-timezone.timedelta(days=30)).exclude(viewer_hash='').update(viewer_hash='')
    SponsorEventTicket.objects.filter(shown_at__isnull=True,expires_at__lt=now-timezone.timedelta(days=1)).delete()
