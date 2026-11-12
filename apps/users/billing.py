from datetime import datetime, timezone as dt_timezone
from decimal import Decimal
import uuid
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
    from apps.tracking.business_web import workspace_context
    context=workspace_context(workspace,request.user,'billing')
    context.update(
        plans=BillingPlan.objects.filter(active=True).order_by('monthly_price', 'member_limit'),
        billing_ready=stripe_ready(),
    )
    context['checkout_pending'] = request.GET.get('checkout') == 'success' and not (
        context['subscription'] and context['subscription'].entitled
    )
    return render(request,'work/billing.html',context)



@login_required(login_url='/work/login/')
@require_POST
def checkout(request, pk):
    workspace = owner_workspace(request, pk)
    if not stripe_ready():
        messages.error(request, 'Online subscriptions are not available right now. Please contact Hearteli support.')
        return redirect('business-billing', pk=pk)

    plan = BillingPlan.objects.filter(pk=request.POST.get('plan'), active=True).first()
    if not plan:
        messages.error(request, 'Choose an available subscription plan.')
        return redirect('business-billing', pk=pk)
    if plan.monthly_price <= Decimal('0'):
        messages.error(request, 'This subscription plan is not configured for checkout. Please contact Hearteli support.')
        return redirect('business-billing', pk=pk)
    if plan.stripe_price_id:
        try:
            stripe_price = stripe.Price.retrieve(
                plan.stripe_price_id,
                api_key=settings.STRIPE_SECRET_KEY,
            )
        except stripe.StripeError:
            messages.error(request, 'We could not verify this subscription price. Please contact Hearteli support.')
            return redirect('business-billing', pk=pk)
        recurring = stripe_price.get('recurring') or {}
        if not (
            stripe_price.get('active')
            and recurring.get('interval') == 'month'
            and stripe_price.get('unit_amount') == int(plan.monthly_price * 100)
            and stripe_price.get('currency', '').lower() == plan.currency.lower()
        ):
            messages.error(request, 'This plan’s Stripe price must be active, monthly, and match the listed price and currency.')
            return redirect('business-billing', pk=pk)

    base_url = settings.HEARTELI_PUBLIC_URL.rstrip('/')
    billing_url = f'{base_url}/work/{pk}/billing/'
    try:
        with transaction.atomic():
            subscription, _ = BusinessSubscription.objects.select_for_update().get_or_create(
                workspace=workspace,
                defaults={'plan': plan, 'manual_status': 'active'},
            )
            if subscription.entitled:
                messages.info(request, 'Your workspace already has an active subscription.')
                return redirect('business-billing', pk=pk)
            if subscription.checkout_session_id:
                previous = stripe.checkout.Session.retrieve(
                    subscription.checkout_session_id,
                    api_key=settings.STRIPE_SECRET_KEY,
                )
                if previous.status == 'open':
                    return redirect(previous.url)
                if previous.status == 'complete':
                    messages.info(request, 'Your payment is being confirmed. Refresh this page in a moment.')
                    return redirect('business-billing', pk=pk)

            subscription.plan = plan
            price = (
                {'price': plan.stripe_price_id, 'quantity': 1}
                if plan.stripe_price_id
                else {
                    'price_data': {
                        'currency': plan.currency.lower(),
                        'unit_amount': int(plan.monthly_price * 100),
                        'recurring': {'interval': 'month'},
                        'product_data': {'name': plan.name},
                    },
                    'quantity': 1,
                }
            )
            session = stripe.checkout.Session.create(
                mode='subscription',
                client_reference_id=str(workspace.pk),
                line_items=[price],
                customer=subscription.customer_id or None,
                customer_email=None if subscription.customer_id else request.user.email,
                subscription_data={
                    'metadata': {
                        'workspace_id': str(workspace.pk),
                        'billing_plan_id': str(plan.pk),
                    },
                },
                success_url=f'{billing_url}?checkout=success',
                cancel_url=billing_url,
                idempotency_key=f'hearteli-work-{workspace.pk}-{plan.pk}-{uuid.uuid4()}',
                api_key=settings.STRIPE_SECRET_KEY,
            )
            subscription.checkout_session_id = session.id
            subscription.save(update_fields=['plan', 'checkout_session_id'])
    except stripe.StripeError:
        messages.error(request, 'We could not start checkout. Please try again or contact Hearteli support.')
        return redirect('business-billing', pk=pk)
    return redirect(session.url)


@login_required(login_url='/work/login/')
@require_POST
def portal(request, pk):
    workspace = owner_workspace(request, pk)
    if not stripe_ready():
        messages.error(request, 'Online subscription management is not available right now. Please contact Hearteli support.')
        return redirect('business-billing', pk=pk)
    subscription = BusinessSubscription.objects.filter(workspace=workspace).first()
    if not subscription or not subscription.customer_id:
        messages.error(request, 'There is no online subscription to manage yet.')
        return redirect('business-billing', pk=pk)
    try:
        session = stripe.billing_portal.Session.create(
            customer=subscription.customer_id,
            return_url=f'{settings.HEARTELI_PUBLIC_URL.rstrip("/")}/work/{pk}/billing/',
            api_key=settings.STRIPE_SECRET_KEY,
        )
    except stripe.StripeError:
        messages.error(request, 'We could not open subscription management. Please try again or contact Hearteli support.')
        return redirect('business-billing', pk=pk)
    return redirect(session.url)



def update_subscription(remote):
    # Always retrieve current provider state, so delayed events cannot restore stale access.
    customer = remote.get('customer')
    if isinstance(customer, dict):
        customer = customer.get('id')
    metadata = remote.get('metadata', {})
    workspace_id = metadata.get('workspace_id')
    from django.db.models import Q
    lookup = Q(customer_id=customer) if customer else Q()
    if workspace_id:
        lookup |= Q(workspace_id=workspace_id)
    if not lookup:
        return
    sub=BusinessSubscription.objects.select_for_update().filter(lookup).first()
    if not sub: return
    if workspace_id and str(sub.workspace_id)!=str(workspace_id): return
    if sub.customer_id and customer and sub.customer_id != customer: return
    items=remote['items']['data']
    if len(items)!=1: return
    plan=BillingPlan.objects.filter(stripe_price_id=items[0]['price']['id']).first()
    if not plan and metadata.get('billing_plan_id'):
        plan=BillingPlan.objects.filter(pk=metadata['billing_plan_id']).first()
    if not plan: return
    if remote.get('currency') and remote['currency']!=plan.currency: return
    sub.plan=plan;sub.stripe_subscription_id=remote['id'];sub.status=remote['status']
    if customer:
        sub.customer_id=customer
    if remote['status'] in ('active','trialing'):
        sub.billing_status='paid'
        if not sub.paid_at:
            sub.paid_at=datetime.now(dt_timezone.utc)
    elif remote['status']=='canceled':
        sub.billing_status='unpaid'
    else:
        sub.billing_status='overdue' if remote['status']=='past_due' else 'unpaid'
    end=remote.get('current_period_end') or items[0].get('current_period_end')
    sub.period_end=datetime.fromtimestamp(end,dt_timezone.utc) if end else None
    sub.cancel_at_period_end=remote.get('cancel_at_period_end',False)
    sub.save()
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
        elif kind in ('checkout.session.completed', 'checkout.session.async_payment_succeeded') and obj.get('mode')=='payment' and obj.get('payment_status')=='paid':
            a=Appointment.objects.select_for_update().filter(payment_checkout_session_id=obj['id']).first()
            payment_intent=obj.get('payment_intent')
            if isinstance(payment_intent, dict):
                payment_intent=payment_intent.get('id')
            if a and payment_intent and obj.get('currency')==a.billing_currency.lower() and obj.get('amount_total')==int(a.fee*100):
                settle_payment(a.pk,payment_intent)
        elif kind=='checkout.session.async_payment_failed' and obj.get('mode')=='payment':
            Appointment.objects.filter(
                payment_checkout_session_id=obj['id'], payment_status='pending'
            ).update(payment_checkout_session_id='')
        elif kind in ('invoice.paid','invoice.payment_failed'):
            subid=obj.get('subscription') or (obj.get('parent') or {}).get('subscription_details',{}).get('subscription')
            if subid: update_subscription(stripe.Subscription.retrieve(subid,api_key=settings.STRIPE_SECRET_KEY))
        elif kind=='payment_intent.succeeded':
            a=Appointment.objects.select_for_update().filter(payment_intent_id=obj['id']).first()
            if a and obj.get('currency')==a.billing_currency.lower() and obj.get('amount_received')==int(a.fee*100):
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
        if previous.status!='expired':
            raise ValidationError('This appointment payment is already being confirmed.')
    session=stripe.checkout.Session.create(mode='payment',client_reference_id=str(a.pk),
        line_items=[{'price_data':{'currency':a.billing_currency.lower(),'unit_amount':int(a.fee*100),
            'product_data':{'name':'Hearteli appointment'}},'quantity':1}],
        payment_intent_data={'metadata':{'appointment_id':str(a.pk)}},
        success_url=settings.HEARTELI_PUBLIC_URL+f'/practice/appointments/{a.pk}/',
        cancel_url=settings.HEARTELI_PUBLIC_URL+f'/practice/appointments/{a.pk}/',idempotency_key=f'hearteli-checkout-{a.pk}-{a.payment_checkout_session_id or "first"}',api_key=settings.STRIPE_SECRET_KEY)
    a.payment_checkout_session_id=session.id;a.save(update_fields=['payment_checkout_session_id'])
    return session.url
