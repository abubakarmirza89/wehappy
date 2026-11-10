"""A privacy-constrained, server-rendered workplace console."""
import hashlib
import secrets
from datetime import timedelta

from django import forms
from django.contrib import messages
from django.contrib.auth import login
from django.contrib.auth.decorators import login_required
from django.contrib.auth.password_validation import validate_password
from django.db import transaction
from django.db.models import Q
from django.core.exceptions import ValidationError
from django.http import HttpResponseForbidden
from django.shortcuts import get_object_or_404, redirect, render
from django.views.decorators.http import require_POST, require_http_methods
from django.utils import timezone
from django.utils.text import slugify
from .models import (
    Workspace, WorkspaceMembership, WorkspaceResource, WorkspaceRoleAudit,
    WorkspaceSignupInvitation,
)
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


class OwnerRegistrationForm(forms.Form):
    name = forms.CharField(max_length=100)
    email = forms.EmailField()
    phone_number = forms.CharField(max_length=20)
    password = forms.CharField(widget=forms.PasswordInput)
    confirm_password = forms.CharField(widget=forms.PasswordInput)

    def clean_name(self):
        name = self.cleaned_data['name'].strip()
        if User.objects.filter(name__iexact=name).exists():
            raise forms.ValidationError('This display name is already in use.')
        return name

    def clean_email(self):
        email = self.cleaned_data['email'].lower()
        if User.objects.filter(email__iexact=email).exists():
            raise forms.ValidationError('Account already exists. Please sign in.')
        return email

    def clean(self):
        data = super().clean()
        if data.get('password') and data.get('confirm_password'):
            if data['password'] != data['confirm_password']:
                self.add_error('confirm_password', 'Passwords do not match.')
            else:
                validate_password(data['password'])
        return data


@require_http_methods(['GET', 'POST'])
def register(request):
    if request.user.is_authenticated:
        return redirect('hearteli-work-index')
    form = OwnerRegistrationForm(request.POST or None)
    invitation_token = (request.POST.get('invite') if request.method == 'POST'
                        else request.GET.get('invite', '')).strip()
    invitation = None
    invitation_invalid = False
    if invitation_token:
        invitation_hash = hashlib.sha256(invitation_token.encode()).hexdigest()
        invitation = WorkspaceSignupInvitation.objects.filter(
            token_hash=invitation_hash,
            claimed_at__isnull=True,
            expires_at__gt=timezone.now(),
        ).select_related('workspace', 'invited_by').first()
        invitation_invalid = invitation is None

    if request.method == 'POST' and form.is_valid():
        if invitation_token and not invitation:
            form.add_error(None, 'This workspace invitation is invalid or has expired. Ask the workspace owner to send another invite.')
            invitation_invalid = True
        elif invitation and invitation.email.casefold() != form.cleaned_data['email'].casefold():
            form.add_error('email', 'Use the email address this workspace invitation was sent to.')
        else:
            with transaction.atomic():
                if invitation:
                    invitation = WorkspaceSignupInvitation.objects.select_for_update().filter(
                        pk=invitation.pk,
                        claimed_at__isnull=True,
                        expires_at__gt=timezone.now(),
                    ).first()
                    if not invitation:
                        form.add_error(None, 'This workspace invitation has already been used or has expired. Ask the workspace owner to send another invite.')
                        invitation_invalid = True
                if not invitation_token or invitation:
                    user = User.objects.create_user(
                        name=form.cleaned_data['name'],
                        email=form.cleaned_data['email'],
                        phone_number=form.cleaned_data['phone_number'],
                        password=form.cleaned_data['password'],
                    )
                    if invitation:
                        WorkspaceMembership.objects.get_or_create(
                            workspace=invitation.workspace,
                            user=user,
                            defaults={
                                'role': WorkspaceMembership.ROLE_EMPLOYEE,
                                'status': WorkspaceMembership.STATUS_PENDING,
                                'invited_by': invitation.invited_by,
                            },
                        )
                        invitation.claimed_at = timezone.now()
                        invitation.save(update_fields=['claimed_at'])
            if not form.errors:
                login(request, user, backend='django.contrib.auth.backends.ModelBackend')
                return redirect('hearteli-work-index')

    return render(request, 'work/register.html', {
        'form': form,
        'invitation': invitation,
        'invitation_token': invitation_token,
        'invitation_invalid': invitation_invalid,
    })


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
    pending_invitations = WorkspaceMembership.objects.filter(
        user=request.user,
        status=WorkspaceMembership.STATUS_PENDING,
        workspace__workspace_type=Workspace.WORKSPACE_TYPE_OFFICE,
        workspace__is_active=True,
    ).select_related('workspace', 'invited_by')
    return render(request, 'work/index.html', {
        'workspaces': workspaces,
        'pending_invitations': pending_invitations,
    })


@login_required(login_url='/work/login/')
@require_POST
def create_workspace(request):
    name = request.POST.get('name', '').strip()
    if not 2 <= len(name) <= 120:
        return HttpResponseForbidden('Provide a workspace name of 2–120 characters.')
    base = slugify(name)[:100] or 'workspace'
    slug, suffix = base, 2
    while Workspace.objects.filter(slug=slug).exists():
        slug = f'{base}-{suffix}'
        suffix += 1
    with transaction.atomic():
        workspace = Workspace.objects.create(owner=request.user, name=name, slug=slug,
            description=request.POST.get('description', '').strip()[:500],
            workspace_type=Workspace.WORKSPACE_TYPE_OFFICE,
            subscription_plan=Workspace.SUBSCRIPTION_PLAN_OFFICE_20)
        WorkspaceMembership.objects.create(workspace=workspace, user=request.user,
            role=WorkspaceMembership.ROLE_OWNER, status=WorkspaceMembership.STATUS_APPROVED,
            designation='Admin', joined_at=timezone.now())
    return redirect('hearteli-work-dashboard', pk=workspace.pk)


@login_required(login_url='/work/login/')
def dashboard(request, pk):
    from .business_web import page
    return page(request, pk)


@login_required(login_url='/work/login/')
@require_POST
@transaction.atomic
def invite(request, pk):
    workspace = admin_workspace(request.user, pk)
    if workspace is None or workspace.owner_id != request.user.id:
        return HttpResponseForbidden('Owner access required.')
    try:
        email = forms.EmailField().clean(request.POST.get('email', '').strip())
    except ValidationError:
        messages.error(request, 'Enter a valid email address to invite a member.')
        return redirect('business-page', pk=pk, section='members')

    member = User.objects.filter(email__iexact=email).first()
    if member and member.id == workspace.owner_id:
        messages.error(request, 'You are already the owner of this workspace.')
        return redirect('business-page', pk=pk, section='members')

    Workspace.objects.select_for_update().get(pk=workspace.pk)
    from .subscriptions import require_subscription, SubscriptionRequired
    try:
        existing_membership = (
            WorkspaceMembership.objects.filter(workspace=workspace, user=member).exists()
            if member and member.is_active else False
        )
        require_subscription(
            workspace,
            adding_member=not existing_membership,
            invite_email=email,
        )
    except SubscriptionRequired as exc:
        messages.error(request, str(exc.detail))
        return redirect('business-page', pk=pk, section='members')

    if member and not member.is_active:
        messages.error(request, 'This email already has an inactive Hearteli account. Ask them to contact support before inviting them.')
    elif member:
        membership, created = WorkspaceMembership.objects.get_or_create(workspace=workspace, user=member, defaults={
            'role': WorkspaceMembership.ROLE_EMPLOYEE, 'status': WorkspaceMembership.STATUS_PENDING,
            'invited_by': request.user})
        messages.success(request,'Invitation sent.' if created else 'This member already has a workspace membership.')
    else:
        token = secrets.token_urlsafe(32)
        invitation = WorkspaceSignupInvitation.objects.filter(
            workspace=workspace,
            email__iexact=email,
            claimed_at__isnull=True,
        ).order_by('-created_at').first()
        token_hash = hashlib.sha256(token.encode()).hexdigest()
        if invitation:
            invitation.invited_by = request.user
            invitation.token_hash = token_hash
            invitation.expires_at = timezone.now() + timedelta(days=30)
            invitation.save(update_fields=['invited_by', 'token_hash', 'expires_at'])
        else:
            invitation = WorkspaceSignupInvitation.objects.create(
                workspace=workspace,
                email=email,
                invited_by=request.user,
                token_hash=token_hash,
                expires_at=timezone.now() + timedelta(days=30),
            )
        from apps.users.communications import send_workspace_signup_invitation
        send_workspace_signup_invitation(invitation, token)
        messages.success(
            request,
            f'{email} does not have a Hearteli account yet. We sent them an email invitation to join Hearteli and {workspace.name}.',
        )
    return redirect('business-page', pk=pk, section='members')


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
    return redirect('business-page', pk=pk, section='members')


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
    return redirect('business-page', pk=pk, section='members')


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
        from django.contrib import messages
        messages.success(request,'Resource published.')
    else:
        from django.contrib import messages
        messages.error(request,' '.join(str(error) for errors in form.errors.values() for error in errors))
    return redirect('business-page', pk=pk, section='resources')


@login_required(login_url='/work/login/')
@require_POST
def remove_resource(request, pk, resource_id):
    workspace = admin_workspace(request.user, pk)
    if workspace is None or workspace.owner_id != request.user.id:
        return HttpResponseForbidden('Owner access required.')
    get_object_or_404(WorkspaceResource, pk=resource_id, workspace=workspace).delete()
    return redirect('business-page', pk=pk, section='resources')
