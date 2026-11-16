from django.test import TestCase
from django.urls import reverse
from apps.users.models import BusinessSubscription, User
from apps.tracking.models import Workspace,WorkspaceMembership
from apps.users.tests.billing_helpers import active_subscription

class BusinessPageTests(TestCase):
    def setUp(self):
        self.owner=User.objects.create_user(name='Page Owner',email='pages@example.com',password='StrongPass123',phone_number='1')
        self.manager=User.objects.create_user(name='Page Manager',email='manager-pages@example.com',password='StrongPass123',phone_number='2')
        self.workspace=Workspace.objects.create(name='Team Pages',owner=self.owner,workspace_type='office')
        WorkspaceMembership.objects.create(workspace=self.workspace,user=self.manager,role='manager',status='approved')
        active_subscription(self.workspace);self.client.force_login(self.owner)
    def url(self,section):return reverse('business-page',args=[self.workspace.pk,section])
    def test_independent_pages_and_active_navigation(self):
        for section in ['overview','members','resources','insights','privacy','settings']:
            r=self.client.get(self.url(section))
            self.assertEqual(r.status_code,200)
            self.assertTemplateUsed(r,f'work/{section}.html')
            self.assertEqual(r.content.decode().count('aria-current="page"'),2)
        r=self.client.get(reverse('business-billing',args=[self.workspace.pk]))
        self.assertTemplateUsed(r,'work/business_layout.html')
        self.assertContains(r,'Workplace settings')
        self.assertEqual(r.content.decode().count('aria-current="page"'),2)
    def test_settings_validate_and_save_without_leaving_settings(self):
        r=self.client.post(self.url('settings'),{'name':'X','description':'bad'})
        self.assertEqual(r.status_code,200);self.assertContains(r,'at least 2')
        self.workspace.refresh_from_db();self.assertEqual(self.workspace.name,'Team Pages')
        r=self.client.post(self.url('settings'),{'name':'Updated Team','description':'Supportive workplace'})
        self.assertRedirects(r,self.url('settings'))
        self.workspace.refresh_from_db();self.assertEqual(self.workspace.name,'Updated Team')
    def test_invite_rotation_requires_confirmation_and_retains_members(self):
        old=self.workspace.invite_code
        self.client.post(self.url('settings'),{'action':'rotate_invite'})
        self.workspace.refresh_from_db();self.assertEqual(old,self.workspace.invite_code)
        self.assertRedirects(self.client.post(self.url('settings'),{'action':'rotate_invite','confirm_rotate':'on'}),self.url('settings'))
        self.workspace.refresh_from_db();self.assertEqual(old,self.workspace.invite_code)
        self.assertEqual(self.workspace.commercial_invitations.count(),1)
        self.assertEqual(self.workspace.memberships.count(),1)
    def test_manager_settings_and_outside_workspace_blocked(self):
        self.client.force_login(self.manager)
        self.assertEqual(self.client.get(self.url('settings')).status_code,403)
        self.assertEqual(self.client.post(self.url('settings'),{'name':'Hacked'}).status_code,403)
        self.assertEqual(self.client.get(reverse('business-billing',args=[self.workspace.pk])).status_code,404)
        other=Workspace.objects.create(name='Other Workspace',owner=self.owner,workspace_type='office')
        self.assertEqual(self.client.get(reverse('business-page',args=[other.pk,'members'])).status_code,403)
    def test_forms_return_to_their_own_section(self):
        pk=self.workspace.pk
        r=self.client.post(reverse('hearteli-work-resource-add',args=[pk]),{'title':'Support','url':'https://example.com'})
        self.assertRedirects(r,self.url('resources'))
        r=self.client.post(reverse('hearteli-work-role',args=[pk,self.workspace.memberships.get().pk]),{'role':'employee'})
        self.assertRedirects(r,self.url('members'))
        self.assertNotContains(self.client.get(self.url('overview')),'name="email"')
        self.assertNotContains(self.client.get(self.url('overview')),'name="description"')

    def test_chooser_renders_real_roles_and_secondary_creation(self):
        path = reverse('hearteli-work-index')
        owner_view = self.client.get(path)
        self.assertContains(owner_view, '<h1>Your workplaces</h1>', html=True)
        self.assertContains(owner_view, 'Create another workplace')
        self.assertContains(owner_view, 'Subscription active')
        self.assertContains(owner_view, 'Open workplace')
        self.assertContains(owner_view, 'Your role: <strong>Owner</strong>')

        self.client.force_login(self.manager)
        manager_view = self.client.get(path)
        self.assertContains(manager_view, 'Your role: <strong>Manager</strong>')
        self.assertNotContains(manager_view, '/billing/')

    def test_inactive_pages_keep_one_notice_and_hide_paid_actions(self):
        BusinessSubscription.objects.filter(workspace=self.workspace).update(
            manual_status='suspended', status='incomplete',
        )
        for section in ('overview', 'members', 'resources', 'insights'):
            with self.subTest(section=section):
                response = self.client.get(self.url(section))
                self.assertContains(response, 'aria-label="Subscription status"', count=1)
                self.assertNotContains(response, 'name="email"')
                self.assertNotContains(response, 'Publish resource')
                self.assertNotContains(response, 'We’re confirming your payment')
        self.assertContains(
            self.client.get(self.url('overview')),
            f'<a href="{self.url("privacy")}">Review privacy boundaries →</a>',
            html=True,
        )
        self.client.force_login(self.manager)
        insights = self.client.get(self.url('insights'))
        self.assertContains(insights, 'Only the owner can access billing')
        self.assertNotContains(insights, '/billing/')
        self.assertNotContains(insights, 'Seats used')

    def test_active_insights_uses_seat_rules_and_excludes_expired_invitations(self):
        from datetime import timedelta

        from django.utils import timezone
        from apps.tracking.models import WorkspaceSignupInvitation

        WorkspaceMembership.objects.create(
            workspace=self.workspace, user=self.owner, role='owner', status='approved',
        )
        for email, days in [('pending@example.com', 1), ('expired@example.com', -1)]:
            WorkspaceSignupInvitation.objects.create(
                workspace=self.workspace, email=email, invited_by=self.owner,
                token_hash=email, expires_at=timezone.now() + timedelta(days=days),
            )
        response = self.client.get(self.url('insights'))
        self.assertEqual(response.context['seats_used'], 2)
        self.assertEqual(response.context['approved_count'], 2)
        self.assertEqual(response.context['pending_count'], 1)
        self.assertContains(response, 'Includes you')
        self.assertContains(response, self.url('members') + '#invite-team')
        self.assertContains(self.client.get(self.url('members')), 'id="invite-team"')
        self.assertNotContains(response, 'expired@example.com')
        self.assertNotContains(response, 'mean_mood')

    def test_support_uses_configured_address(self):
        with self.settings(HEARTELI_WORK_SUPPORT_EMAIL='work-help@example.test'):
            self.assertContains(self.client.get(reverse('hearteli-work-support')),
                                'mailto:work-help@example.test')

    def test_billing_does_not_treat_redirect_as_payment_and_checks_stored_session(self):
        from unittest.mock import patch

        url = reverse('business-billing', args=[self.workspace.pk])
        BusinessSubscription.objects.filter(workspace=self.workspace).update(
            manual_status='suspended', status='incomplete',
        )
        with self.settings(STRIPE_SECRET_KEY='sk_test_configured', STRIPE_WEBHOOK_SECRET='whsec_test'):
            with patch('apps.users.billing.stripe.checkout.Session.retrieve') as retrieve:
                response = self.client.get(url + '?checkout=success')
                retrieve.assert_not_called()
                self.assertNotContains(response, 'Check payment status')
                BusinessSubscription.objects.filter(workspace=self.workspace).update(
                    checkout_session_id='cs_test_existing',
                )
                retrieve.return_value = {
                    'mode': 'subscription', 'status': 'complete', 'payment_status': 'paid',
                    'client_reference_id': str(self.workspace.pk),
                }
                response = self.client.get(url)
                retrieve.assert_called_once()
                self.assertContains(response, 'Your subscription hasn’t activated yet')
                self.assertContains(response, 'Check payment status')
                self.assertNotContains(response, 'type="submit">Subscribe')
