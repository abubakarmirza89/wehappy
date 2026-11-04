from datetime import date,timedelta
import hashlib
from django.test import TestCase
from django.utils import timezone
from rest_framework.test import APIClient
from apps.users.models import *
from apps.users.marketplace import quote_booking,public_reviews
from apps.users.commercial_tasks import refresh_commercial_state
from apps.tracking.models import Workspace,WorkspaceMembership,MoodCheckIn,CircleConnection,EmpathyNudge,HearteliPreferences
from .billing_helpers import approved_provider,active_subscription
import uuid

class MonetisationTests(TestCase):
    def setUp(self):
        self.user=User.objects.create_user(name='Marketplace Client',email='market-client@example.com',password='StrongPass123!',phone_number='1',date_of_birth=date(1990,1,1))
        self.therapist=User.objects.create_user(name='Marketplace Provider',email='market-provider@example.com',password='StrongPass123!',phone_number='2',is_therapist=True,date_of_birth=date(1980,1,1))
        self.admin=User.objects.create_user(name='Market Admin',email='market-admin@example.com',password='StrongPass123!',phone_number='3',is_staff=True)
        self.option=approved_provider(self.therapist,fee=100,duration=45)
        self.profile=self.therapist.therapist_profile
        self.api=APIClient();self.api.force_authenticate(self.user)
        self.now=timezone.now()
    def campaign(self,placement='search'):
        return SponsorCampaign.objects.create(name='Campaign',sponsor_name='Sponsor',placement=placement,therapist=self.profile if placement=='search' else None,status='approved',starts_at=self.now-timedelta(days=1),ends_at=self.now+timedelta(days=1),approved_by=self.admin,destination='https://example.com',impression_cap=10)
    def search(self,**kwargs):return self.api.get('/api/users/marketplace/search/',kwargs).data
    def test_sponsored_verified_and_organic_independent_and_no_duplicates(self):
        c=self.campaign();data=self.search()
        self.assertEqual(len(data['sponsored']),1);self.assertEqual(data['organic'],[])
        self.assertTrue(data['sponsored'][0]['verified'])
        c.status='paused';c.save()
        data=self.search();self.assertEqual(data['sponsored'],[]);self.assertEqual(len(data['organic']),1)
        self.profile.refresh_from_db();self.assertTrue(self.profile.verified)
    def test_expired_verification_hidden_even_with_active_sponsorship(self):
        self.campaign();self.profile.verification_expires_at=self.now-timedelta(seconds=1);self.profile.save()
        self.assertEqual(self.search(),{'sponsored':[],'organic':[]})
        self.assertEqual(self.api.post(f'/api/users/create-appointment/{self.therapist.pk}/',{'offering_id':self.option.pk,'date':'2027-01-01','time':'10:00','location':'Online','reason':'Support'}).status_code,400)
    def test_filter_applies_to_sponsored_and_organic(self):
        self.campaign()
        self.assertEqual(self.search(max_fee=50)['sponsored'],[])
        self.assertEqual(self.search(duration=60)['sponsored'],[])
        self.assertEqual(self.search(duration=45)['sponsored'][0]['id'],self.therapist.pk)
    def test_fetch_is_not_impression_and_events_are_idempotent(self):
        c=self.campaign();data=self.search();ticket=data['sponsored'][0]['sponsor']['event_id']
        self.assertEqual(c.tickets.filter(shown_at__isnull=False).count(),0)
        event={'event_id':ticket,'event_type':'impression','visible_fraction':.6,'visible_ms':1100}
        for _ in range(2):self.assertEqual(self.api.post('/api/users/sponsor-events/',event,format='json').status_code,200)
        for _ in range(2):self.assertEqual(self.api.post('/api/users/sponsor-events/',{'event_id':ticket,'event_type':'click'},format='json').status_code,200)
        self.assertEqual(c.tickets.filter(shown_at__isnull=False).count(),1);self.assertEqual(c.tickets.filter(clicked_at__isnull=False).count(),1)
    def test_invalid_events_and_click_before_visibility_rejected(self):
        self.campaign();t=self.search()['sponsored'][0]['sponsor']['event_id']
        self.assertEqual(self.api.post('/api/users/sponsor-events/',{'event_id':'bad','event_type':'click'}).status_code,400)
        self.assertEqual(self.api.post('/api/users/sponsor-events/',{'event_id':t,'event_type':'click'}).status_code,400)
        self.assertEqual(self.api.post('/api/users/sponsor-events/',{'event_id':t,'event_type':'impression','visible_fraction':.1,'visible_ms':1000}).status_code,400)
    def test_inactive_provider_hidden_and_confirmation_restores_only_verified(self):
        self.campaign();self.profile.last_activity_confirmation=self.now-timedelta(days=46);self.profile.save()
        self.assertEqual(self.profile.activity_status,'inactive');self.assertEqual(self.search()['sponsored'],[])
        self.api.force_authenticate(self.therapist)
        self.assertTrue(self.api.post('/api/users/therapist/confirm-activity/',{},format='json').data['search_visible'])
        self.profile.refresh_from_db();self.profile.verification_status='suspended';self.profile.save()
        self.assertFalse(self.api.post('/api/users/therapist/confirm-activity/',{},format='json').data['search_visible'])
    def test_commission_source_frozen_and_policy_configurable(self):
        platform=quote_booking(self.user,self.therapist,self.option.pk)
        referred=quote_booking(self.user,self.therapist,self.option.pk,str(self.profile.referral_code))
        self.assertEqual(platform['commission'],15);self.assertEqual(referred['commission'],5)
        Appointment.objects.create(user=self.user,therapist=self.therapist,date=self.now.date()+timedelta(days=1),time='10:00',location='Online',reason='Private',**platform)
        self.assertEqual(quote_booking(self.user,self.therapist,self.option.pk,str(self.profile.referral_code))['acquisition_source'],'platform')
        p=MarketplacePolicy.current();p.platform_commission=12;p.save()
        self.assertEqual(quote_booking(self.user,self.therapist,self.option.pk)['commission'],12)
    def test_unapproved_duration_or_fee_cannot_be_booked(self):
        self.option.approved=False;self.option.save()
        from rest_framework.exceptions import ValidationError
        with self.assertRaises(ValidationError):quote_booking(self.user,self.therapist,self.option.pk)
    def test_review_submission_not_automatically_public(self):
        a=Appointment.objects.create(user=self.user,therapist=self.therapist,date=self.now.date(),time='10:00',location='Online',reason='Private',status='COMPLETED',payment_status='paid',booking_credential_verified=True)
        r=self.api.post(f'/api/users/feedback/{self.therapist.pk}/',{'appointment_id':a.pk,'rating':5,'comment':'Helpful'})
        self.assertEqual(r.status_code,201);self.assertEqual(public_reviews(self.therapist.pk).count(),0)
        Feedback.objects.update(moderation_status='approved',public_visibility=True)
        self.assertEqual(public_reviews(self.therapist.pk).count(),0)
    def test_unknown_age_does_not_receive_sponsored_search(self):
        self.campaign();self.user.date_of_birth=None;self.user.save()
        self.assertEqual(self.search()['sponsored'],[]);self.assertEqual(len(self.search()['organic']),1)
    def test_organisation_expiry_preserves_personal_data_and_credentials(self):
        w=Workspace.objects.create(owner=self.user,name='Expiry Pilot',workspace_type='office')
        sub=active_subscription(w);sub.period_end=self.now-timedelta(seconds=1);sub.save()
        checkin=MoodCheckIn.objects.create(user=self.user,feeling_category='good',notes='Private')
        refresh_commercial_state();sub.refresh_from_db();self.assertEqual(sub.manual_status,'expired')
        self.user.refresh_from_db();self.assertTrue(self.user.is_active);self.assertTrue(MoodCheckIn.objects.filter(pk=checkin.pk).exists())
        self.profile.refresh_from_db();self.assertTrue(self.profile.verified)
        self.assertEqual(self.api.get('/api/tracking/mood-check-ins/').status_code,200)
    def test_atomic_invites_capacity_expiry_and_duplicate_seats(self):
        w=Workspace.objects.create(owner=self.admin,name='Seat Pilot',workspace_type='office');sub=active_subscription(w);sub.plan.member_limit=1;sub.plan.save()
        inv=OrganisationInvitation.objects.create(workspace=w,token_hash=hashlib.sha256(b'secret').hexdigest(),expires_at=self.now+timedelta(days=1),max_redemptions=1,created_by=self.admin)
        path='/api/users/organisation-invitations/redeem/'
        self.assertEqual(self.api.post(path,{'token':'secret'}).status_code,201)
        self.assertEqual(self.api.post(path,{'token':'secret'}).status_code,200)
        self.assertEqual(w.memberships.count(),1);self.assertEqual(inv.redemptions.count(),1)
        self.api.force_authenticate(self.therapist);self.assertEqual(self.api.post(path,{'token':'secret'}).status_code,400)
        inv.revoked_at=self.now;inv.save();self.assertEqual(self.api.post(path,{'token':'secret'}).status_code,400)
    def test_nudge_ads_safe_default_and_explicit_eligibility(self):
        c=self.campaign('nudge');m=MoodCheckIn.objects.create(user=self.therapist,feeling_category='okay')
        CircleConnection.objects.create(owner=self.therapist,recipient=self.user,accepted_at=self.now,may_receive_nudges=True)
        n=EmpathyNudge.objects.create(sender=self.therapist,recipient=self.user,check_in=m,message='Please check in',delivery_status='opened',idempotency_key=uuid.uuid4())
        EmpathyNudge.objects.filter(pk=n.pk).update(delivery_status='opened')
        path=f'/api/users/nudges/{n.pk}/sponsor/'
        self.assertIsNone(self.api.get(path).data)
        p=MarketplacePolicy.current();p.nudge_sponsors_enabled=True;p.nudge_ad_policy_reference='Approved placement policy';p.save()
        HearteliPreferences.objects.update_or_create(user=self.user,defaults={'sponsor_opt_in':True})
        n.support_context='ordinary';n.save()
        payload=self.api.get(path).data;self.assertEqual(payload['label'],'Sponsored');self.assertNotIn('Please check in',str(payload))
        n.support_context='safety';n.save();self.assertIsNone(self.api.get(path).data)
    def test_activity_reminder_and_existing_bookings_preserved(self):
        self.profile.last_activity_confirmation=self.now-timedelta(days=46);self.profile.save()
        a=Appointment.objects.create(user=self.user,therapist=self.therapist,date=self.now.date()+timedelta(days=1),time='10:00',location='Online',reason='Private')
        refresh_commercial_state();refresh_commercial_state()
        self.assertTrue(Appointment.objects.filter(pk=a.pk).exists())
        self.assertEqual(EmailDelivery.objects.filter(kind='activity_confirmation',channel='email',recipient=self.therapist).count(),1)
        self.assertEqual(EmailDelivery.objects.filter(kind='inactive_provider',channel='email',recipient=self.admin).count(),1)
    def test_manual_entitlements_ignore_stripe_status(self):
        w=Workspace.objects.create(owner=self.user,name='Manual Pilot',workspace_type='office');sub=active_subscription(w);sub.manual_status='suspended';sub.status='active';sub.save()
        self.assertFalse(sub.entitled)
        self.client.force_login(self.user)
        self.assertEqual(self.client.post(f'/work/{w.pk}/billing/checkout/',{'plan':sub.plan_id}).status_code,410)
    def test_expiry_hides_organisation_resources_without_touching_personal_data(self):
        from apps.tracking.models import WorkspaceResource
        w=Workspace.objects.create(owner=self.user,name='Resource Pilot',workspace_type='office')
        sub=active_subscription(w)
        WorkspaceResource.objects.create(workspace=w,title='Pilot resource',url='https://example.com')
        self.assertEqual(len(self.api.get('/api/tracking/workspace-resources/').data),1)
        sub.period_end=self.now-timedelta(seconds=1);sub.save()
        self.assertEqual(len(self.api.get('/api/tracking/workspace-resources/').data),0)
        self.client.force_login(self.user)
        self.assertEqual(self.client.get(f'/work/{w.pk}/pages/resources/').status_code,402)
        self.assertTrue(User.objects.get(pk=self.user.pk).is_active)
    def test_campaign_attribution_and_expiry_remove_placement(self):
        from apps.users.monetisation import attribute_booking
        c=self.campaign();t=self.search()['sponsored'][0]['sponsor']['event_id']
        self.api.post('/api/users/sponsor-events/',{'event_id':t,'event_type':'impression','visible_fraction':.5,'visible_ms':1000},format='json')
        a=Appointment.objects.create(user=self.user,therapist=self.therapist,date=self.now.date()+timedelta(days=1),time='10:00',location='Online',reason='Private')
        attribute_booking(a,t)
        self.assertTrue(SponsorBookingAttribution.objects.filter(appointment=a).exists())
        c.ends_at=self.now-timedelta(seconds=1);c.save()
        self.assertEqual(self.search()['sponsored'],[])
        self.assertEqual(self.api.post('/api/users/sponsor-events/',{'event_id':t,'event_type':'click'},format='json').status_code,400)
    def test_internal_reports_do_not_expose_personal_information(self):
        self.campaign()
        self.client.force_login(self.user)
        self.assertEqual(self.client.get('/commercial/reports/sponsors/').status_code,403)
        self.admin.is_superuser=True;self.admin.save()
        self.client.force_login(self.admin)
        response=self.client.get('/commercial/reports/sponsors/?from=2026-01-01&to=2027-01-01')
        self.assertEqual(response.status_code,200)
        self.assertNotIn(self.user.email,response.content.decode())
        self.assertNotIn(self.therapist.name,response.content.decode())
        self.assertEqual(self.client.get('/commercial/reports/sponsors/?from=2027-01-01&to=2026-01-01').status_code,400)
    def test_marketplace_pages_and_four_state_preview(self):
        self.campaign();self.client.force_login(self.user)
        self.assertContains(self.client.get('/therapy/'),'Sponsored')
        self.assertContains(self.client.get(f'/therapy/{self.therapist.pk}/'),'Verified')
        self.assertEqual(self.client.get('/marketplace/preview/').status_code,403)
        self.admin.is_superuser=True;self.admin.save();self.client.force_login(self.admin)
        self.assertContains(self.client.get('/marketplace/preview/'),'Booking unavailable',count=2)
