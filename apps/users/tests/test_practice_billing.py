from decimal import Decimal
from datetime import timedelta
from unittest.mock import patch
from django.utils import timezone
from django.test import TestCase,override_settings
from rest_framework.test import APIClient
from apps.users.models import User,Appointment,TherapistApplication,TherapyLedger,WithdrawalRequest,BillingPlan,BusinessSubscription,PaymentEvent
from apps.users.therapy_services import settle_payment,refund_payment,balance
from apps.tracking.models import Workspace,WorkspaceMembership

class PracticeBillingTests(TestCase):
    def setUp(self):
        self.member=User.objects.create_user(name='Client',email='client@example.com',password='StrongPass123',phone_number='1')
        self.therapist=User.objects.create_user(name='Therapist',email='therapist@example.com',password='StrongPass123',phone_number='2',is_therapist=True)
        self.other=User.objects.create_user(name='Other',email='other@example.com',password='StrongPass123',phone_number='3')
        self.api=APIClient();self.api.force_authenticate(self.member)
        self.a=Appointment.objects.create(user=self.member,therapist=self.therapist,date=timezone.now().date()+timedelta(days=1),time='10:00',location='Online',reason='Support',fee=100)
        self.workspace=Workspace.objects.create(name='Business',owner=self.member,workspace_type='office')
        from .billing_helpers import approved_provider
        self.offering=approved_provider(self.therapist)
        self.plan=BillingPlan.objects.create(name='Team',stripe_price_id='price_test',monthly_price=20,member_limit=2)
    def test_net_credit_once_and_refund_once(self):
        settle_payment(self.a.pk,'pi_test');settle_payment(self.a.pk,'pi_test')
        self.assertEqual(balance(self.therapist)['available_balance'],Decimal('85'))
        self.a.refresh_from_db();self.assertEqual(self.a.commission,Decimal('15'))
        refund_payment(self.a.pk);refund_payment(self.a.pk)
        self.assertEqual(TherapyLedger.objects.count(),2)
        self.assertEqual(balance(self.therapist)['available_balance'],0)
    def test_withdrawal_reserves_and_blocks_double_spend(self):
        settle_payment(self.a.pk,'pi_test');self.api.force_authenticate(self.therapist)
        url='/api/users/therapist/withdrawals/'
        self.assertEqual(self.api.post(url,{'amount':'60','payout_account':'bank'}).status_code,201)
        self.assertEqual(self.api.post(url,{'amount':'60','payout_account':'bank'}).status_code,400)
        WithdrawalRequest.objects.update(status='rejected')
        self.assertEqual(balance(self.therapist)['available_balance'],85)
    def test_application_does_not_self_approve(self):
        url='/api/users/therapist/application/'
        payload={'bio':'Professional bio','credentials':'MSc','license_number':'ABC','location':'Karachi','modalities':'Online','status':'approved'}
        self.assertEqual(self.api.post(url,payload).status_code,201)
        self.member.refresh_from_db();self.assertFalse(self.member.is_therapist)
        self.assertEqual(TherapistApplication.objects.get(user=self.member).status,'pending')
        self.assertEqual(self.api.post(url,payload).status_code,400)
    def test_chat_permissions_and_cancelled_read_only(self):
        url=f'/api/users/appointment/{self.a.pk}/messages/'
        self.assertEqual(self.api.post(url,{'body':'Hello'}).status_code,201)
        self.api.force_authenticate(self.other);self.assertEqual(self.api.get(url).status_code,403)
        self.api.force_authenticate(self.therapist);self.assertEqual(len(self.api.get(url).data),1)
        self.a.status='CANCELED';self.a.save()
        self.assertEqual(self.api.post(url,{'body':'Hello'}).status_code,400)
    def test_optional_profile_cannot_change_approval(self):
        self.api.force_authenticate(self.member)
        self.assertEqual(self.api.patch('/api/users/therapist/profile/',{'is_available':True}).status_code,403)
        self.api.force_authenticate(self.therapist)
        self.assertEqual(self.api.patch('/api/users/therapist/profile/',{'hourly_rate':'-5'}).status_code,400)
        self.assertEqual(self.api.patch('/api/users/therapist/profile/',{'is_available':False},format='json').status_code,200)
    def test_subscription_expiry_and_billing_owner_scope(self):
        sub=BusinessSubscription.objects.create(workspace=self.workspace,plan=self.plan,status='active',manual_status='active',period_end=timezone.now()+timedelta(days=1))
        self.assertTrue(sub.entitled)
        sub.period_end=timezone.now()-timedelta(seconds=1);self.assertFalse(sub.entitled)
        self.client.force_login(self.other)
        self.assertEqual(self.client.get(f'/work/{self.workspace.pk}/billing/').status_code,404)

    @override_settings(STRIPE_SECRET_KEY='', STRIPE_WEBHOOK_SECRET='')
    def test_business_checkout_shows_unavailable_message_when_stripe_is_not_configured(self):
        subscription=BusinessSubscription.objects.create(
            workspace=self.workspace,
            plan=self.plan,
            manual_status='active',
            organisation_status='active',
            period_end=timezone.now()+timedelta(days=1),
        )
        self.client.force_login(self.member)
        response=self.client.post(
            f'/work/{self.workspace.pk}/billing/checkout/',{'plan':self.plan.pk}
        )
        self.assertEqual(response.status_code,302)
        subscription.refresh_from_db()
        self.assertEqual(subscription.checkout_session_id,'')
        page=self.client.get(response['Location'])
        self.assertContains(page,'Online checkout is not available right now')

    @override_settings(STRIPE_SECRET_KEY='sk_test', STRIPE_WEBHOOK_SECRET='whsec_test')
    @patch('apps.users.billing.stripe.checkout.Session.create')
    def test_business_checkout_creates_stripe_subscription_session(self, create):
        create.return_value.id='cs_workspace'
        create.return_value.url='https://checkout.stripe.test/session'
        self.client.force_login(self.member)

        response=self.client.post(
            f'/work/{self.workspace.pk}/billing/checkout/', {'plan':self.plan.pk}
        )

        self.assertEqual(response.status_code,302)
        self.assertEqual(response['Location'],'https://checkout.stripe.test/session')
        subscription=BusinessSubscription.objects.get(workspace=self.workspace)
        self.assertEqual(subscription.checkout_session_id,'cs_workspace')
        self.assertEqual(create.call_args.kwargs['mode'],'subscription')
        self.assertEqual(
            create.call_args.kwargs['subscription_data']['metadata']['workspace_id'],
            str(self.workspace.pk),
        )
        self.assertEqual(
            create.call_args.kwargs['subscription_data']['metadata']['billing_plan_id'],
            str(self.plan.pk),
        )
    def test_gated_write_and_seat_limit(self):
        self.plan.member_limit=1;self.plan.save()
        self.client.force_login(self.member)
        url=f'/work/{self.workspace.pk}/invite/'
        self.assertEqual(self.client.post(url,{'email':self.other.email}).status_code,402)
        BusinessSubscription.objects.create(workspace=self.workspace,plan=self.plan,status='active',manual_status='active',period_end=timezone.now()+timedelta(days=1))
        WorkspaceMembership.objects.create(workspace=self.workspace,user=self.member,role='owner',status='approved')
        self.assertEqual(self.client.post(url,{'email':self.other.email}).status_code,302)
        self.assertEqual(self.client.post(url,{'email':self.therapist.email}).status_code,402)
    def test_checkout_unconfigured_does_not_create_earnings(self):
        self.assertEqual(self.api.post(f'/api/users/appointment/{self.a.pk}/checkout/').status_code,400)
        self.assertEqual(TherapyLedger.objects.count(),0)

    @override_settings(STRIPE_SECRET_KEY='sk_test', STRIPE_WEBHOOK_SECRET='whsec_test')
    @patch('apps.users.billing.stripe.checkout.Session.create')
    @patch('apps.users.billing.stripe.checkout.Session.retrieve')
    def test_completed_checkout_cannot_create_a_second_charge(self, retrieve, create):
        self.a.payment_checkout_session_id='cs_paid'
        self.a.save(update_fields=['payment_checkout_session_id'])
        retrieve.return_value.status='complete'
        self.assertEqual(self.api.post(f'/api/users/appointment/{self.a.pk}/checkout/').status_code,400)
        create.assert_not_called()
        self.assertEqual(self.api.post(f'/api/users/appointment/{self.a.pk}/payment/').status_code,404)

    @patch('apps.users.billing.stripe.Webhook.construct_event')
    def test_checkout_webhook_settles_and_links_payment_for_refunds(self, construct):
        self.a.payment_checkout_session_id='cs_paid'
        self.a.save(update_fields=['payment_checkout_session_id'])
        construct.return_value={'id':'evt_checkout','type':'checkout.session.async_payment_succeeded','data':{'object':{
            'id':'cs_paid','mode':'payment','payment_status':'paid','currency':'usd','amount_total':10000,'payment_intent':'pi_checkout'
        }}}
        url='/api/users/webhook/stripe/'
        self.assertEqual(self.client.post(url,data='{}',content_type='application/json').status_code,200)
        self.a.refresh_from_db()
        self.assertEqual(self.a.payment_intent_id,'pi_checkout')
        self.assertEqual(self.a.payment_status,'paid')
        construct.return_value={'id':'evt_refund','type':'charge.refunded','data':{'object':{
            'payment_intent':'pi_checkout','refunded':True
        }}}
        self.assertEqual(self.client.post(url,data='{}',content_type='application/json').status_code,200)
        self.a.refresh_from_db()
        self.assertEqual(self.a.payment_status,'refunded')
        self.assertEqual(balance(self.therapist)['available_balance'],0)
    @patch('apps.users.billing.stripe.Webhook.construct_event')
    def test_signed_webhook_idempotency_and_amount_validation(self,construct):
        self.a.payment_intent_id='pi_test';self.a.save()
        event={'id':'evt_1','type':'payment_intent.succeeded','data':{'object':{'id':'pi_test','currency':'usd','amount_received':10000}}}
        construct.return_value=event
        url='/api/users/webhook/stripe/'
        self.assertEqual(self.client.post(url,data='{}',content_type='application/json').status_code,200)
        self.client.post(url,data='{}',content_type='application/json')
        self.assertEqual(TherapyLedger.objects.count(),1)
        self.assertEqual(balance(self.therapist)['available_balance'],85)
    def test_dashboard_and_web_pages_render(self):
        self.client.force_login(self.therapist)
        practice_page=self.client.get('/practice/')
        self.assertContains(practice_page,'Your practice')
        self.assertContains(practice_page,'/practice/profile/')
        self.assertNotContains(practice_page,'/work/')
        self.assertEqual(self.client.get('/practice/profile/').status_code,200)
        from .billing_helpers import active_subscription
        active_subscription(self.workspace)
        self.client.force_login(self.member)
        for page in ['members','resources','settings','insights']:
            work_page=self.client.get(f'/work/{self.workspace.pk}/pages/{page}/')
            self.assertEqual(work_page.status_code,200)
            self.assertNotContains(work_page,'/practice/')
            self.assertNotContains(work_page,'/therapy/')
        self.assertContains(self.client.get(f'/work/{self.workspace.pk}/billing/'),'Plans &amp; billing')

    def test_unsigned_webhook_is_rejected(self):
        self.assertEqual(self.client.post('/api/users/webhook/stripe/',data='{}',content_type='application/json').status_code,400)
        self.assertEqual(PaymentEvent.objects.count(),0)

    @patch('apps.users.billing.stripe.Subscription.retrieve')
    @patch('apps.users.billing.stripe.Webhook.construct_event')
    def test_subscription_access_uses_verified_current_state(self,construct,retrieve):
        sub=BusinessSubscription.objects.create(workspace=self.workspace,plan=self.plan,customer_id='cus_test')
        remote={'id':'sub_test','customer':'cus_test','status':'past_due','metadata':{'workspace_id':str(self.workspace.pk)},'items':{'data':[{'price':{'id':'price_test'},'current_period_end':int((timezone.now()+timedelta(days=30)).timestamp())}]}}
        retrieve.return_value=remote
        construct.return_value={'id':'evt_sub1','type':'customer.subscription.updated','data':{'object':{'id':'sub_test'}}}
        self.client.post('/api/users/webhook/stripe/',data='{}',content_type='application/json')
        sub.refresh_from_db();self.assertFalse(sub.entitled)
        remote['status']='active';construct.return_value['id']='evt_sub2'
        self.client.post('/api/users/webhook/stripe/',data='{}',content_type='application/json')
        sub.refresh_from_db();self.assertFalse(sub.entitled) # Stripe state must not activate a manual entitlement

    def test_admin_approval_enables_role_and_profile(self):
        from apps.users.admin import TherapistApplicationAdmin
        from django.contrib import admin
        from types import SimpleNamespace
        app=TherapistApplication.objects.create(user=self.member,bio='Bio',credentials='MSc',license_number='ABC',location='Karachi')
        TherapistApplicationAdmin(TherapistApplication,admin.site).approve(SimpleNamespace(user=self.other),TherapistApplication.objects.filter(pk=app.pk))
        self.member.refresh_from_db();self.assertTrue(self.member.is_therapist)
        self.assertTrue(self.member.therapist_profile.is_active)

    def test_provider_web_booking_and_self_booking_blocked(self):
        profile=self.therapist.therapist_profile;profile.hourly_rate=100;profile.is_available=True;profile.save()
        self.client.force_login(self.member)
        self.assertEqual(self.client.get('/therapy/').status_code,200)
        response=self.client.post(f'/therapy/{self.therapist.pk}/',{'offering_id':self.offering.pk,'date':str(timezone.now().date()+timedelta(days=2)),'time':'12:00','location':'Online','reason':'Support'})
        self.assertEqual(response.status_code,302)
        booking=Appointment.objects.exclude(pk=self.a.pk).get();self.assertEqual(booking.commission,15);self.assertEqual(booking.therapist_earnings,85)
        self.assertEqual(TherapyLedger.objects.count(),0)
        self.api.force_authenticate(self.therapist)
        self.assertEqual(self.api.post(f'/api/users/create-appointment/{self.therapist.pk}/',{'date':str(timezone.now().date()+timedelta(days=3)),'time':'12:00','location':'Online','reason':'Support'}).status_code,400)

    def test_therapist_web_login_opens_practice(self):
        response=self.client.post('/practice/login/',{'username':self.therapist.email,'password':'StrongPass123'})
        self.assertRedirects(response,'/practice/')

    def test_work_login_does_not_route_therapists_to_practice(self):
        response=self.client.post('/work/login/',{'username':self.therapist.email,'password':'StrongPass123'})
        self.assertRedirects(response,'/work/')
