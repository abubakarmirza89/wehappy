from datetime import timedelta
from django.utils import timezone
from apps.users.models import BillingPlan,BusinessSubscription

def active_subscription(workspace):
    plan,_=BillingPlan.objects.get_or_create(stripe_price_id='price_suite',defaults={'name':'Test business plan','monthly_price':20,'member_limit':20})
    return BusinessSubscription.objects.create(workspace=workspace,plan=plan,status='active',period_end=timezone.now()+timedelta(days=30))
