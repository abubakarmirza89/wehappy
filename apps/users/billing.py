from datetime import datetime, timezone as dt_timezone
from decimal import Decimal
import stripe
from django.conf import settings
from django.db import transaction
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required
from django.shortcuts import get_object_or_404, redirect, render
from django.contrib import messages
from .models import BillingPlan, BusinessSubscription, PaymentEvent, Appointment
from apps.tracking.models import Workspace
from .therapy_services import settle_payment, refund_payment


def stripe_ready():
    return bool(settings.STRIPE_SECRET_KEY and not settings.STRIPE_SECRET_KEY.endswith('dummy') and settings.STRIPE_WEBHOOK_SECRET)


def owner_workspace(request, pk):
    return get_object_or_404(Workspace, pk=pk, owner=request.user, workspace_type='office')


@login_required(login_url='/work/login/')
def billing_page(request, pk):
    workspace = owner_workspace(request, pk)
    sub = BusinessSubscription.objects.filter(workspace=workspace).select_related('plan').first()
    return render(request,'work/billing.html',{'workspace':workspace,'subscription':sub,
        'plans':BillingPlan.objects.filter(active=True),'billing_ready':stripe_ready()})


@login_required(login_url='/work/login/')
@require_POST
def checkout(request, pk):
    workspace = owner_workspace(request, pk)
    plan = get_object_or_404(BillingPlan, pk=request.POST.get('plan'), active=True)
    if not stripe_ready():
        messages.error(request,'Billing is not configured yet. Please contact the workspace administrator.')
        return redirect('business-billing',pk=pk)
    with transaction.atomic():
        Workspace.objects.select_for_update().get(pk=pk)
        sub = BusinessSubscription.objects.filter(workspace=workspace).first()
        if sub and sub.stripe_subscription_id and sub.status not in ('canceled','incomplete_expired'):
            messages.info(request,'Manage your existing subscription in the billing portal.')
            return redirect('business-billing',pk=pk)
        if sub and sub.checkout_session_id:
            existing=stripe.checkout.Session.retrieve(sub.checkout_session_id,api_key=settings.STRIPE_SECRET_KEY)
            if existing.status=='open': return redirect(existing.url)
        customer = stripe.Customer.retrieve(sub.customer_id,api_key=settings.STRIPE_SECRET_KEY) if sub and sub.customer_id else stripe.Customer.create(email=request.user.email,metadata={'workspace_id':str(pk)},idempotency_key=f'hearteli-workspace-customer-{pk}',api_key=settings.STRIPE_SECRET_KEY)
        if not sub:
            sub=BusinessSubscription.objects.create(workspace=workspace,plan=plan,customer_id=customer.id)
        else:
            sub.plan=plan;sub.customer_id=customer.id;sub.save()
        price=stripe.Price.retrieve(plan.stripe_price_id,api_key=settings.STRIPE_SECRET_KEY)
        if price.currency!=plan.currency or price.unit_amount!=int(plan.monthly_price*100) or price.recurring.interval!='month':
            messages.error(request,'The selected plan needs administrator configuration.')
            return redirect('business-billing',pk=pk)
        session=stripe.checkout.Session.create(mode='subscription',customer=customer.id,
            line_items=[{'price':plan.stripe_price_id,'quantity':1}],
            client_reference_id=str(pk),subscription_data={'metadata':{'workspace_id':str(pk)}},
            metadata={'workspace_id':str(pk)},success_url=settings.HEARTELI_PUBLIC_URL+f'/work/{pk}/billing/',
            cancel_url=settings.HEARTELI_PUBLIC_URL+f'/work/{pk}/billing/',idempotency_key=f'hearteli-subscription-{pk}-{plan.pk}-{sub.checkout_session_id or "first"}',api_key=settings.STRIPE_SECRET_KEY)
        sub.checkout_session_id=session.id;sub.save(update_fields=['checkout_session_id'])
    return redirect(session.url)


@login_required(login_url='/work/login/')
@require_POST
def portal(request, pk):
    workspace=owner_workspace(request,pk)
    sub=get_object_or_404(BusinessSubscription,workspace=workspace)
    if not stripe_ready() or not sub.customer_id:
        messages.error(request,'Billing is not configured yet.')
        return redirect('business-billing',pk=pk)
    session=stripe.billing_portal.Session.create(customer=sub.customer_id,
        return_url=settings.HEARTELI_PUBLIC_URL+f'/work/{pk}/billing/',api_key=settings.STRIPE_SECRET_KEY)
    return redirect(session.url)


def update_subscription(remote):
    # Always retrieve current provider state, so delayed events cannot restore stale access.
    sub=BusinessSubscription.objects.select_for_update().filter(customer_id=remote['customer']).first()
    if not sub: return
    metadata=remote.get('metadata',{})
    if str(sub.workspace_id)!=str(metadata.get('workspace_id')): return
    items=remote['items']['data']
    if len(items)!=1: return
    plan=BillingPlan.objects.filter(stripe_price_id=items[0]['price']['id']).first()
    if not plan: return
    if remote.get('currency') and remote['currency']!=plan.currency: return
    sub.plan=plan;sub.stripe_subscription_id=remote['id'];sub.status=remote['status']
    end=remote.get('current_period_end') or items[0].get('current_period_end')
    sub.period_end=datetime.fromtimestamp(end,dt_timezone.utc) if end else None
    sub.cancel_at_period_end=remote.get('cancel_at_period_end',False);sub.save()
    from .communications import queue_email
    queue_email(sub.workspace.owner,'subscription','Your Hearteli workspace subscription update',
        f'Your workspace subscription is {sub.status}. Open billing to review renewal, invoices or payment details.',
        key=f'subscription:{sub.pk}:{sub.status}:{end}:{sub.cancel_at_period_end}',path=f'/work/{sub.workspace_id}/billing/')


@csrf_exempt
@require_POST
def webhook(request):
    try:
        event=stripe.Webhook.construct_event(request.body,request.headers.get('Stripe-Signature',''),settings.STRIPE_WEBHOOK_SECRET)
    except (ValueError, stripe.SignatureVerificationError):
        return HttpResponse(status=400)
    with transaction.atomic():
        _,created=PaymentEvent.objects.get_or_create(event_id=event['id'])
        if not created: return HttpResponse(status=200)
        kind=event['type'];obj=event['data']['object']
        if kind.startswith('customer.subscription.'):
            remote=stripe.Subscription.retrieve(obj['id'],api_key=settings.STRIPE_SECRET_KEY)
            update_subscription(remote)
        elif kind=='checkout.session.completed' and obj.get('mode')=='subscription' and obj.get('subscription'):
            update_subscription(stripe.Subscription.retrieve(obj['subscription'],api_key=settings.STRIPE_SECRET_KEY))
        elif kind=='checkout.session.completed' and obj.get('mode')=='payment' and obj.get('payment_status')=='paid':
            a=Appointment.objects.select_for_update().filter(payment_checkout_session_id=obj['id']).first()
            if a and obj.get('currency')==settings.HEARTELI_CURRENCY and obj.get('amount_total')==int(a.fee*100):
                settle_payment(a.pk,obj['payment_intent'])
        elif kind in ('invoice.paid','invoice.payment_failed'):
            subid=obj.get('subscription') or (obj.get('parent') or {}).get('subscription_details',{}).get('subscription')
            if subid: update_subscription(stripe.Subscription.retrieve(subid,api_key=settings.STRIPE_SECRET_KEY))
        elif kind=='payment_intent.succeeded':
            a=Appointment.objects.select_for_update().filter(payment_intent_id=obj['id']).first()
            if a and obj.get('currency')==settings.HEARTELI_CURRENCY and obj.get('amount_received')==int(a.fee*100):
                settle_payment(a.pk,obj['id'])
        elif kind=='charge.refunded':
            a=Appointment.objects.select_for_update().filter(payment_intent_id=obj.get('payment_intent')).first()
            # Partial refunds need their own approved allocation policy; do not reverse the full earning.
            if a and obj.get('refunded') is True:
                refund_payment(a.pk)
    return HttpResponse(status=200)


def appointment_checkout(a):
    from rest_framework.exceptions import ValidationError
    if not stripe_ready(): raise ValidationError('Payments are not configured yet.')
    if a.payment_status!='pending' or a.status!='BOOKED' or a.fee<=0: raise ValidationError('This booking cannot be charged.')
    if a.payment_checkout_session_id:
        previous=stripe.checkout.Session.retrieve(a.payment_checkout_session_id,api_key=settings.STRIPE_SECRET_KEY)
        if previous.status=='open': return previous.url
    session=stripe.checkout.Session.create(mode='payment',client_reference_id=str(a.pk),
        line_items=[{'price_data':{'currency':settings.HEARTELI_CURRENCY,'unit_amount':int(a.fee*100),
            'product_data':{'name':'Hearteli appointment'}},'quantity':1}],
        payment_intent_data={'metadata':{'appointment_id':str(a.pk)}},
        success_url=settings.HEARTELI_PUBLIC_URL+f'/practice/appointments/{a.pk}/',
        cancel_url=settings.HEARTELI_PUBLIC_URL+f'/practice/appointments/{a.pk}/',idempotency_key=f'hearteli-checkout-{a.pk}-{a.payment_checkout_session_id or "first"}',api_key=settings.STRIPE_SECRET_KEY)
    a.payment_checkout_session_id=session.id;a.save(update_fields=['payment_checkout_session_id'])
    return session.url
