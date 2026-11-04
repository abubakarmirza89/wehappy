from django.test import TestCase
from django.urls import reverse
from apps.users.models import User
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
            self.assertEqual(r.content.decode().count('aria-current="page"'),1)
        r=self.client.get(reverse('business-billing',args=[self.workspace.pk]))
        self.assertTemplateUsed(r,'work/business_layout.html')
        self.assertContains(r,'Workspace settings')
        self.assertEqual(r.content.decode().count('aria-current="page"'),1)
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
        self.workspace.refresh_from_db();self.assertNotEqual(old,self.workspace.invite_code)
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
