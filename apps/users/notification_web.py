from django.contrib.auth.decorators import login_required
from django.shortcuts import render, get_object_or_404, redirect
from django.views.decorators.http import require_http_methods
from django.utils import timezone
from django.db.models import Q
from .models import Notification
from apps.tracking.models import CircleConnection, EmpathyNudge


@login_required(login_url='/work/login/')
def inbox(request):
    notifications = Notification.objects.filter(recipient=request.user)[:100]
    accepted = CircleConnection.objects.filter(recipient=request.user, accepted_at__isnull=False,
        may_receive_nudges=True).values('owner_id')
    nudges = EmpathyNudge.objects.filter(Q(sender=request.user) | Q(recipient=request.user,
        sender_id__in=accepted)).select_related('sender', 'recipient').order_by('-created_at')[:50]
    return render(request, 'work/notifications.html', {'notifications': notifications, 'nudges': nudges})


@login_required(login_url='/work/login/')
@require_http_methods(['GET', 'POST'])
def nudge_detail(request, pk):
    accepted = CircleConnection.objects.filter(recipient=request.user, accepted_at__isnull=False,
        may_receive_nudges=True).values('owner_id')
    nudge = get_object_or_404(EmpathyNudge.objects.filter(Q(sender=request.user) |
        Q(recipient=request.user, sender_id__in=accepted)), pk=pk)
    if request.method == 'POST' and request.user.pk == nudge.recipient_id and nudge.status == 'sent':
        choice = request.POST.get('status')
        if choice in ('acknowledged', 'cannot_help'):
            nudge.status = choice
            nudge.responded_at = timezone.now()
            nudge.save(update_fields=['status', 'responded_at'])
            return redirect('hearteli-nudge-detail', pk=pk)
    if request.user.pk == nudge.recipient_id:
        EmpathyNudge.objects.filter(pk=pk).update(delivery_status='opened')
    return render(request, 'work/nudge_detail.html', {'nudge': nudge})
