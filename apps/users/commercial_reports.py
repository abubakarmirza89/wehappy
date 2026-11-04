"""Internal aggregate exports; no client, mood, Circle or nudge content."""
import csv
from datetime import datetime,time,timedelta,timezone as utc
from django.contrib.auth.decorators import permission_required
from django.http import HttpResponse,JsonResponse
from django.utils import timezone
from django.utils.dateparse import parse_date
from .models import SponsorCampaign,BusinessSubscription

@permission_required('users.view_sponsorcampaign',raise_exception=True)
def sponsors(request):
    try:
        start=parse_date(request.GET.get('from','')) or timezone.now().date()-timedelta(days=30)
        end=parse_date(request.GET.get('to','')) or timezone.now().date()
        if end<start:raise ValueError()
    except (ValueError,TypeError):return JsonResponse({'detail':'Use valid YYYY-MM-DD from/to dates.'},status=400)
    start=datetime.combine(start,time.min,tzinfo=utc.utc);end=datetime.combine(end+timedelta(days=1),time.min,tzinfo=utc.utc)
    response=HttpResponse(content_type='text/csv');response['Content-Disposition']='attachment; filename="hearteli-sponsors.csv"'
    writer=csv.writer(response);writer.writerow(['Campaign ID','Status','Campaign start','Campaign end','Reporting start inclusive','Reporting end exclusive','Impressions','Clicks','CTR percent','Booking starts'])
    for c in SponsorCampaign.objects.filter(starts_at__lt=end,ends_at__gte=start):
        impressions=c.tickets.filter(shown_at__gte=start,shown_at__lt=end).count();clicks=c.tickets.filter(clicked_at__gte=start,clicked_at__lt=end).count()
        writer.writerow([c.pk,c.status,c.starts_at.isoformat(),c.ends_at.isoformat(),start.isoformat(),end.isoformat(),impressions,clicks,round(100*clicks/impressions,2) if impressions else 0,c.tickets.filter(booking_started_at__gte=start,booking_started_at__lt=end).count()])
    return response

@permission_required('users.view_businesssubscription',raise_exception=True)
def organisations(request):
    response=HttpResponse(content_type='text/csv');response['Content-Disposition']='attachment; filename="hearteli-organisations.csv"'
    writer=csv.writer(response);writer.writerow(['Organisation ID','Subscription status','Seat limit','Joined seats','Invitations issued','Invitations redeemed','Activation and retention'])
    for sub in BusinessSubscription.objects.select_related('workspace','plan'):
        w=sub.workspace
        writer.writerow([w.pk,sub.effective_status,sub.plan.member_limit,w.memberships.filter(status='approved').exclude(user_id=w.owner_id).count(),w.commercial_invitations.count(),sum(i.redemptions.count() for i in w.commercial_invitations.all()),'Suppressed: no personal activity reporting enabled'])
    return response
