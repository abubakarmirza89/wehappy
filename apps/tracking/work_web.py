"""A privacy-constrained, server-rendered workplace console."""
from django import forms
from django.contrib.auth.decorators import login_required
from django.db.models import Q
from django.http import HttpResponseForbidden
from django.shortcuts import get_object_or_404, redirect, render
from django.views.decorators.http import require_POST
from django.utils import timezone
from .models import Workspace, WorkspaceMembership, WorkspaceResource, WorkspaceRoleAudit
from apps.users.models import User


class ResourceForm(forms.ModelForm):
    class Meta:
        model = WorkspaceResource
        fields = ['title', 'description', 'url']

    def clean_url(self):
        value = self.cleaned_data['url']
        if not value.startswith('https://'):
            raise forms.ValidationError('Use an HTTPS link.')
        return value


def admin_workspace(user, pk):
    workspace = get_object_or_404(Workspace, pk=pk, workspace_type=Workspace.WORKSPACE_TYPE_OFFICE,
                                  is_active=True)
    approved = WorkspaceMembership.objects.filter(workspace=workspace, user=user,
        status=WorkspaceMembership.STATUS_APPROVED, role__in=[WorkspaceMembership.ROLE_OWNER,
                                                               WorkspaceMembership.ROLE_MANAGER]).exists()
    return workspace if (workspace.owner_id == user.id or approved) else None


@login_required(login_url='/work/login/')
def index(request):
    workspaces = Workspace.objects.filter(workspace_type=Workspace.WORKSPACE_TYPE_OFFICE,
        is_active=True).filter(Q(owner=request.user) | Q(memberships__user=request.user,
        memberships__status=WorkspaceMembership.STATUS_APPROVED,
        memberships__role__in=[WorkspaceMembership.ROLE_OWNER,
                                WorkspaceMembership.ROLE_MANAGER])).distinct()
    return render(request, 'work/index.html', {'workspaces': workspaces})


@login_required(login_url='/work/login/')
def dashboard(request, pk):
    workspace = admin_workspace(request.user, pk)
    if workspace is None:
        return HttpResponseForbidden('You do not have admin access to this workspace.')
    members = workspace.memberships.select_related('user').order_by('role', 'user__name')
    approved_count = members.filter(status=WorkspaceMembership.STATUS_APPROVED).count()
    context = {
        'workspace': workspace, 'members': members,
        'approved_count': approved_count, 'pending_count': members.filter(status='pending').count(),
        'aggregate_available': False, 'privacy_threshold': 10,
        'resources': workspace.resources.order_by('title'),
        'role_events': workspace.role_events.select_related('actor', 'member').order_by('-created_at')[:20],
        'is_owner': workspace.owner_id == request.user.id,
        'form': ResourceForm(),
    }
    return render(request, 'work/dashboard.html', context)


@login_required(login_url='/work/login/')
@require_POST
def invite(request, pk):
    workspace = admin_workspace(request.user, pk)
    if workspace is None or workspace.owner_id != request.user.id:
        return HttpResponseForbidden('Owner access required.')
    email = request.POST.get('email', '').strip()
    member = User.objects.filter(email__iexact=email, is_active=True).first()
    if member and member.id != workspace.owner_id:
        WorkspaceMembership.objects.get_or_create(workspace=workspace, user=member, defaults={
            'role': WorkspaceMembership.ROLE_EMPLOYEE, 'status': WorkspaceMembership.STATUS_PENDING,
            'invited_by': request.user})
    return redirect('hearteli-work-dashboard', pk=pk)


@login_required(login_url='/work/login/')
@require_POST
def approve(request, pk, member_id):
    workspace = admin_workspace(request.user, pk)
    if workspace is None or workspace.owner_id != request.user.id:
        return HttpResponseForbidden('Owner access required.')
    membership = get_object_or_404(WorkspaceMembership, workspace=workspace, pk=member_id)
    if membership.user_id != workspace.owner_id:
        membership.status = WorkspaceMembership.STATUS_APPROVED
        membership.joined_at = timezone.now()
        membership.save(update_fields=['status', 'joined_at'])
    return redirect('hearteli-work-dashboard', pk=pk)


@login_required(login_url='/work/login/')
@require_POST
def role(request, pk, member_id):
    workspace = admin_workspace(request.user, pk)
    if workspace is None or workspace.owner_id != request.user.id:
        return HttpResponseForbidden('Owner access required.')
    membership = get_object_or_404(WorkspaceMembership, workspace=workspace, pk=member_id)
    next_role = request.POST.get('role')
    if membership.user_id != workspace.owner_id and next_role in (
        WorkspaceMembership.ROLE_EMPLOYEE, WorkspaceMembership.ROLE_MANAGER):
        previous = membership.role
        membership.role = next_role
        membership.can_share_mood_with_manager = False
        membership.save(update_fields=['role', 'can_share_mood_with_manager'])
        WorkspaceRoleAudit.objects.create(workspace=workspace, actor=request.user,
            member=membership.user, from_role=previous, to_role=next_role)
    return redirect('hearteli-work-dashboard', pk=pk)


@login_required(login_url='/work/login/')
@require_POST
def add_resource(request, pk):
    workspace = admin_workspace(request.user, pk)
    if workspace is None or workspace.owner_id != request.user.id:
        return HttpResponseForbidden('Owner access required.')
    form = ResourceForm(request.POST)
    if form.is_valid():
        item = form.save(commit=False)
        item.workspace = workspace
        item.save()
    return redirect('hearteli-work-dashboard', pk=pk)


@login_required(login_url='/work/login/')
@require_POST
def remove_resource(request, pk, resource_id):
    workspace = admin_workspace(request.user, pk)
    if workspace is None or workspace.owner_id != request.user.id:
        return HttpResponseForbidden('Owner access required.')
    get_object_or_404(WorkspaceResource, pk=resource_id, workspace=workspace).delete()
    return redirect('hearteli-work-dashboard', pk=pk)
