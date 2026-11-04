"""A privacy-constrained, server-rendered workplace console."""
from django import forms
from django.contrib import messages
from django.contrib.auth import login
from django.contrib.auth.decorators import login_required
from django.contrib.auth.password_validation import validate_password
from django.db import transaction
from django.db.models import Q
from django.http import HttpResponseForbidden
from django.shortcuts import get_object_or_404, redirect, render
from django.views.decorators.http import require_POST, require_http_methods
from django.utils import timezone
from django.utils.text import slugify
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
    if request.method == 'POST' and form.is_valid():
        user = User.objects.create_user(name=form.cleaned_data['name'],
            email=form.cleaned_data['email'], phone_number=form.cleaned_data['phone_number'],
            password=form.cleaned_data['password'])
        login(request, user, backend='django.contrib.auth.backends.ModelBackend')
        return redirect('hearteli-work-index')
    return render(request, 'work/register.html', {'form': form})


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
@require_POST
def create_workspace(request):
    if not request.user.is_staff:
        return HttpResponseForbidden('Pilot organisations are created by Hearteli administrators.')
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
    email = request.POST.get('email', '').strip()
    member = User.objects.filter(email__iexact=email, is_active=True).first()
    if member and member.id != workspace.owner_id:
        Workspace.objects.select_for_update().get(pk=workspace.pk)
        from .subscriptions import require_subscription,SubscriptionRequired
        try:
            require_subscription(workspace,adding_member=not WorkspaceMembership.objects.filter(workspace=workspace,user=member).exists())
        except SubscriptionRequired as exc:
            from django.http import JsonResponse
            return JsonResponse({'detail':str(exc.detail)},status=402)
        membership, created = WorkspaceMembership.objects.get_or_create(workspace=workspace, user=member, defaults={
            'role': WorkspaceMembership.ROLE_EMPLOYEE, 'status': WorkspaceMembership.STATUS_PENDING,
            'invited_by': request.user})
        messages.success(request,'Invitation sent.' if created else 'This member already has a workspace membership.')
    else:
        messages.error(request,'Choose another existing Hearteli member using their account email.')
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
