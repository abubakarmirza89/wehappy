from decimal import Decimal
from django.db import transaction
from django.db.models import Sum
from .models import User, TherapyLedger, WithdrawalRequest, Appointment


def balance(user):
    earned = TherapyLedger.objects.filter(therapist=user).aggregate(total=Sum('amount'))['total'] or Decimal('0')
    reserved = WithdrawalRequest.objects.filter(therapist=user, status__in=['pending','approved','paid']).aggregate(total=Sum('amount'))['total'] or Decimal('0')
    return {'total_earned': earned, 'reserved_or_paid': reserved, 'available_balance': earned-reserved}


@transaction.atomic
def settle_payment(appointment_id, payment_id):
    a = Appointment.objects.select_for_update().get(pk=appointment_id)
    User.objects.select_for_update().get(pk=a.therapist_id)
    if a.payment_status == 'refunded':
        return
    # A verified payment event, not session completion, creates the earning.
    commission = (a.fee * Decimal('.10')).quantize(Decimal('.01'))
    net = a.fee - commission
    entry, created = TherapyLedger.objects.get_or_create(event_key=f'appointment:{a.pk}:earning', defaults={
        'therapist':a.therapist, 'appointment':a, 'amount':net, 'kind':'earning'})
    if created:
        a.commission = commission; a.therapist_earnings = net
    a.payment_status = 'paid'; a.payment_intent_id = payment_id
    a.save(update_fields=['commission','therapist_earnings','payment_status','payment_intent_id'])


@transaction.atomic
def refund_payment(appointment_id):
    a = Appointment.objects.select_for_update().get(pk=appointment_id)
    User.objects.select_for_update().get(pk=a.therapist_id)
    credit = TherapyLedger.objects.filter(appointment=a, kind='earning').first()
    if credit:
        TherapyLedger.objects.get_or_create(event_key=f'appointment:{a.pk}:refund', defaults={
            'therapist':a.therapist,'appointment':a,'amount':-credit.amount,'kind':'refund'})
    a.payment_status = 'refunded'; a.save(update_fields=['payment_status'])
