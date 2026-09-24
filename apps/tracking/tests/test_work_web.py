from django.contrib.auth import get_user_model
from django.test import TestCase

from apps.tracking.models import Workspace, WorkspaceMembership, WorkspaceResource, WorkspaceRoleAudit


class WorkConsoleTests(TestCase):
    def setUp(self):
        user = get_user_model()
        self.owner = user.objects.create_user(name='Owner', email='owner@hearteli.test',
                                              phone_number='+923001234560', password='StrongPass123')
        self.employee = user.objects.create_user(name='Employee', email='employee@hearteli.test',
                                                 phone_number='+923001234561', password='StrongPass123')
        self.workspace = Workspace.objects.create(owner=self.owner, name='Office',
            workspace_type=Workspace.WORKSPACE_TYPE_OFFICE)
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
        self.assertContains(response, 'Team Wellbeing')
        self.assertNotContains(response, 'Invite a member')

    def test_new_owner_can_register_and_create_workplace(self):
        response = self.client.post('/work/register/', {
            'name': 'New Owner', 'email': 'new-owner@hearteli.test',
            'phone_number': '+923001234563', 'password': 'StrongerPass123!',
            'confirm_password': 'StrongerPass123!'})
        self.assertRedirects(response, '/work/')
        response = self.client.post('/work/new/', {'name': 'New Team'})
        workspace = Workspace.objects.get(name='New Team')
        self.assertRedirects(response, f'/work/{workspace.pk}/')
        self.assertTrue(WorkspaceMembership.objects.filter(workspace=workspace,
            role=WorkspaceMembership.ROLE_OWNER,
            status=WorkspaceMembership.STATUS_APPROVED).exists())

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
