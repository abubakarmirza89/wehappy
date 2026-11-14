from datetime import timedelta
from django.utils import timezone
from apps.users.models import BillingPlan,BusinessSubscription

def active_subscription(workspace):
    plan,_=BillingPlan.objects.get_or_create(stripe_price_id='price_suite',defaults={'name':'Test business plan','monthly_price':20,'member_limit':20})
    return BusinessSubscription.objects.create(workspace=workspace,plan=plan,status='active',manual_status='active',period_end=timezone.now()+timedelta(days=30))


def approved_provider(user,fee=100,duration=60):
    from apps.users.models import SessionOffering
    p=user.therapist_profile;p.verification_status='verified';p.verification_expires_at=timezone.now()+timedelta(days=365);p.is_available=True;p.directory_published_at=timezone.now();p.save()
    return SessionOffering.objects.create(therapist=p,duration_minutes=duration,fee=fee,approved=True)
