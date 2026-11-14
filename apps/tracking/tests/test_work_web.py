import hashlib
from urllib.parse import parse_qs, urlparse
from datetime import timedelta

from django.core import mail
from django.contrib.auth import get_user_model
from django.test import TestCase, override_settings
from django.utils import timezone
from apps.users.models import BusinessSubscription
from apps.users.tests.billing_helpers import active_subscription

from apps.tracking.models import (
    Workspace, WorkspaceMembership, WorkspaceResource, WorkspaceRoleAudit,
    WorkspaceSignupInvitation,
)


class WorkConsoleTests(TestCase):
    def setUp(self):
        user = get_user_model()
        self.owner = user.objects.create_user(name='Owner', email='owner@hearteli.test',
                                              phone_number='+923001234560', password='StrongPass123')
        self.employee = user.objects.create_user(name='Employee', email='employee@hearteli.test',
                                                 phone_number='+923001234561', password='StrongPass123')
        self.workspace = Workspace.objects.create(owner=self.owner, name='Office',
            workspace_type=Workspace.WORKSPACE_TYPE_OFFICE)
        active_subscription(self.workspace)
        self.member = WorkspaceMembership.objects.create(workspace=self.workspace, user=self.employee,
            role=WorkspaceMembership.ROLE_EMPLOYEE, status=WorkspaceMembership.STATUS_APPROVED)

    def test_employee_cannot_see_or_mutate_console(self):
        self.client.force_login(self.employee)
        path = f'/work/{self.workspace.pk}/'
        self.assertEqual(self.client.get(path).status_code, 403)
        self.assertEqual(self.client.post(path + 'resources/',
            {'title': 'Resource', 'url': 'https://example.com'}).status_code, 403)
        self.assertEqual(self.client.post(path + f'role/{self.member.pk}/',
            {'role': 'manager'}).status_code, 403)

    def test_landing_manager_and_registration(self):
        self.assertContains(self.client.get('/'), 'Stronger people,')
        self.member.role = WorkspaceMembership.ROLE_MANAGER
        self.member.save(update_fields=['role'])
        self.client.force_login(self.employee)
        response = self.client.get(f'/work/{self.workspace.pk}/')
        self.assertContains(response, 'Overview')
        self.assertNotContains(response, 'Invite a member')

    def verify_and_login(self, email, password='StrongerPass123!'):
        from apps.users.email_verification import email_token
        user = get_user_model().objects.get(email=email)
        self.assertEqual(self.client.post('/work/login/', {'username': email, 'password': password}).status_code, 200)
        self.assertNotIn('_auth_user_id', self.client.session)
        self.assertContains(self.client.post(f'/verify-email/{user.pk}/{email_token.make_token(user)}/'), 'Email confirmed')
        self.assertRedirects(self.client.post('/work/login/', {'username': email, 'password': password}), '/work/')

    def test_new_owner_can_register_and_create_workplace(self):
        self.assertContains(self.client.get('/work/register/'), 'Create a therapist account and apply')
        response = self.client.post('/work/register/', {
            'name': 'New Owner', 'email': 'new-owner@hearteli.test',
            'phone_number': '+923001234563', 'password': 'StrongerPass123!',
            'confirm_password': 'StrongerPass123!'})
        self.assertRedirects(response, '/verification-pending/')
        self.verify_and_login('new-owner@hearteli.test')
        response = self.client.post('/work/new/', {'name': 'New Team'})
        self.assertEqual(response.status_code, 302)
        workspace = Workspace.objects.get(name='New Team')
        self.assertRedirects(response, f'/work/{workspace.pk}/')
        self.assertTrue(WorkspaceMembership.objects.filter(workspace=workspace,
            role=WorkspaceMembership.ROLE_OWNER,
            status=WorkspaceMembership.STATUS_APPROVED).exists())
        self.assertContains(self.client.get(f'/work/{workspace.pk}/'), 'Subscribe to activate this workspace')
        self.assertContains(self.client.get(f'/work/{workspace.pk}/billing/'), 'Available plans')
        self.assertFalse(BusinessSubscription.objects.filter(workspace=workspace).exists())

    @override_settings(
        EMAIL_BACKEND='django.core.mail.backends.locmem.EmailBackend',
        HEARTELI_PUBLIC_URL='https://hearteli.test',
    )
    def test_non_member_workspace_invite_emails_signup_link_and_claims_membership(self):
        self.client.force_login(self.owner)
        response = self.client.post(
            f'/work/{self.workspace.pk}/invite/',
            {'email': 'new-member@hearteli.test'},
        )

        self.assertRedirects(
            response,
            f'/work/{self.workspace.pk}/pages/members/',
        )
        self.assertEqual(len(mail.outbox), 1)
        invitation = WorkspaceSignupInvitation.objects.get(workspace=self.workspace)
        self.assertEqual(invitation.email, 'new-member@hearteli.test')
        self.assertIn(self.owner.name, mail.outbox[0].body)
        self.assertIn(self.workspace.name, mail.outbox[0].body)
        invite_url = next(
            word for word in mail.outbox[0].body.split()
            if word.startswith('https://hearteli.test/work/register/')
        )
        token = parse_qs(urlparse(invite_url).query)['invite'][0]
        self.assertNotEqual(invitation.token_hash, token)

        self.client.logout()
        signup_page = self.client.get(f'/work/register/?invite={token}')
        self.assertContains(signup_page, f'You’re invited by {self.owner.name}')
        self.assertContains(signup_page, 'value="new-member@hearteli.test"')
        response = self.client.post('/work/register/', {
            'invite': token,
            'name': 'Invited Member',
            'email': 'new-member@hearteli.test',
            'phone_number': '+923001234564',
            'password': 'StrongerPass123!',
            'confirm_password': 'StrongerPass123!',
        })

        self.assertRedirects(response, '/verification-pending/')
        self.verify_and_login('new-member@hearteli.test')
        member = get_user_model().objects.get(email='new-member@hearteli.test')
        membership = WorkspaceMembership.objects.get(workspace=self.workspace, user=member)
        self.assertEqual(membership.status, WorkspaceMembership.STATUS_PENDING)
        self.assertEqual(membership.invited_by, self.owner)
        invitation.refresh_from_db()
        self.assertIsNotNone(invitation.claimed_at)
        self.assertContains(self.client.get('/work/'), self.workspace.name)
        self.assertContains(self.client.get('/work/'), self.owner.name)

    @override_settings(EMAIL_BACKEND='django.core.mail.backends.locmem.EmailBackend')
    def test_invite_requires_subscription_with_readable_members_page_message(self):
        BusinessSubscription.objects.filter(workspace=self.workspace).delete()
        self.client.force_login(self.owner)

        response = self.client.post(
            f'/work/{self.workspace.pk}/invite/',
            {'email': 'new-member@hearteli.test'},
        )
        self.assertRedirects(
            response,
            f'/work/{self.workspace.pk}/pages/members/',
            fetch_redirect_response=False,
        )
        response = self.client.get(f'/work/{self.workspace.pk}/pages/members/')
        self.assertContains(response, 'An active subscription is required before you can invite members.')
        self.assertContains(response, 'Go to Plans & billing')
        self.assertNotContains(response, 'Send invitation')
        self.assertEqual(mail.outbox, [])
        self.assertFalse(WorkspaceSignupInvitation.objects.exists())

        response = self.client.get(f'/work/{self.workspace.pk}/pages/resources/')
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Subscribe to use workplace resources')

    def test_invitation_signup_requires_the_invited_email_address(self):
        invitation = WorkspaceSignupInvitation.objects.create(
            workspace=self.workspace,
            email='invited@hearteli.test',
            invited_by=self.owner,
            token_hash=hashlib.sha256(b'raw-invite-token').hexdigest(),
            expires_at=timezone.now() + timedelta(days=1),
        )
        response = self.client.post('/work/register/', {
            'invite': 'raw-invite-token',
            'name': 'Wrong Email',
            'email': 'someone-else@hearteli.test',
            'phone_number': '+923001234564',
            'password': 'StrongerPass123!',
            'confirm_password': 'StrongerPass123!',
        })
        self.assertContains(response, 'Use the email address this workspace invitation was sent to.')
        self.assertFalse(get_user_model().objects.filter(email='someone-else@hearteli.test').exists())
        invitation.refresh_from_db()
        self.assertIsNone(invitation.claimed_at)

    def test_owner_resources_role_audit_and_private_dashboard(self):
        self.client.force_login(self.owner)
        path = f'/work/{self.workspace.pk}/'
        response = self.client.get(path)
        self.assertEqual(response.status_code, 200)
        self.assertNotContains(response, 'average_mood_score')
        self.assertEqual(self.client.post(path + 'resources/',
            {'title': 'Support', 'url': 'http://insecure.example'}).status_code, 302)
        self.assertFalse(WorkspaceResource.objects.exists())
        self.client.post(path + 'resources/', {'title': 'Support', 'url': 'https://example.com'})
        self.assertEqual(WorkspaceResource.objects.count(), 1)
        self.member.can_share_mood_with_manager = True
        self.member.save()
        self.client.post(path + f'role/{self.member.pk}/', {'role': 'manager'})
        self.member.refresh_from_db()
        self.assertEqual(self.member.role, WorkspaceMembership.ROLE_MANAGER)
        self.assertFalse(self.member.can_share_mood_with_manager)
        self.assertEqual(WorkspaceRoleAudit.objects.count(), 1)

    def test_resource_api_scopes_visibility_and_mutation(self):
        resource = WorkspaceResource.objects.create(workspace=self.workspace, title='Support',
            url='https://example.com')
        self.client.force_login(self.employee)
        self.assertEqual(self.client.get('/api/tracking/workspace-resources/').status_code, 200)
        self.assertEqual(self.client.patch(f'/api/tracking/workspace-resources/{resource.pk}/',
            {'title': 'Changed'}, content_type='application/json').status_code, 403)
        outsider = get_user_model().objects.create_user(name='Outsider', email='outside@hearteli.test',
            phone_number='+923001234562', password='StrongPass123')
        self.client.force_login(outsider)
        self.assertEqual(self.client.get(f'/api/tracking/workspace-resources/{resource.pk}/').status_code, 404)

    def test_resource_api_hides_content_when_stripe_subscription_is_past_due(self):
        resource = WorkspaceResource.objects.create(
            workspace=self.workspace, title='Support', url='https://example.com'
        )
        subscription = BusinessSubscription.objects.get(workspace=self.workspace)
        subscription.stripe_subscription_id = 'sub_past_due'
        subscription.status = 'past_due'
        subscription.save(update_fields=['stripe_subscription_id', 'status'])

        self.client.force_login(self.owner)
        response = self.client.get('/api/tracking/workspace-resources/')

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data, [])
